from datetime import datetime, timedelta
import time

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from ...config import settings
from ...core.database import get_db
from ...core.services import create_notification
from ...models import Listing, Order
from ..schemas import OrderCancelRequest, OrderCreateRequest
from ..serializers import pagination, serialize_order

router = APIRouter(tags=["orders"])


@router.post("/orders", status_code=201)
def create_order(body: OrderCreateRequest, db: Session = Depends(get_db)):
    listing = db.get(Listing, body.listingId)
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")
    if listing.status != "active":
        raise HTTPException(status_code=400, detail="Listing is not available")

    buyer_id = settings.current_user_id
    if buyer_id == listing.seller_id:
        raise HTTPException(status_code=400, detail="Cannot buy your own listing")

    order = Order(
        id=f"ord_{int(time.time() * 1000)}",
        buyer_id=buyer_id,
        seller_id=listing.seller_id,
        listing_id=listing.id,
        listing_title=listing.title,
        listing_image=listing.images[0] if listing.images else "",
        price=listing.price,
        currency=listing.currency,
        status="pending",
        shipping_address=body.shippingAddress,
        payment_method=body.paymentMethod,
        is_paid=bool(body.paymentMethod),
        quantity=body.quantity,
    )
    db.add(order)
    listing.status = "reserved"
    create_notification(
        db,
        user_id=listing.seller_id,
        title="New Order",
        body=f"{order.listing_title} has been reserved. Review the order in your Orders tab.",
        type="order",
        data={"orderId": order.id},
    )
    db.commit()
    db.refresh(order)
    return serialize_order(order)


@router.get("/orders")
def get_orders(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    status: str | None = None,
    db: Session = Depends(get_db),
):
    query = select(Order).where(Order.buyer_id == settings.current_user_id)
    if status:
        query = query.where(Order.status == status)
    query = query.order_by(Order.created_at.desc())

    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    return pagination([serialize_order(o) for o in rows], page, limit, total)


@router.get("/orders/{order_id}")
def get_order(order_id: str, db: Session = Depends(get_db)):
    order = db.get(Order, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return serialize_order(order)


@router.post("/orders/{order_id}/cancel")
def cancel_order(order_id: str, body: OrderCancelRequest | None = None, db: Session = Depends(get_db)):
    order = db.get(Order, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    if order.status == "delivered":
        raise HTTPException(status_code=400, detail="Cannot cancel a delivered order")
    order.status = "cancelled"
    db.commit()
    db.refresh(order)
    return serialize_order(order)


@router.get("/orders/{order_id}/track")
def track_order(order_id: str, db: Session = Depends(get_db)):
    order = db.get(Order, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    created = order.created_at
    return {
        "orderId": order.id,
        "status": order.status,
        "tracking": [
            {"status": "Order placed", "date": created.isoformat()},
            {"status": "Payment confirmed", "date": (created + timedelta(hours=1)).isoformat()},
            {"status": "Shipped", "date": (created + timedelta(days=1)).isoformat()},
        ],
        "estimatedDelivery": (datetime.now() + timedelta(days=3)).isoformat(),
    }
