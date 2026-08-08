from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from ...core.database import get_db
from ...core.security import get_current_user
from ...core.services import create_notification, generate_id
from ...models import Listing, Order, User
from ..schemas import OrderCancelRequest, OrderCreateRequest
from ..serializers import pagination, serialize_order

router = APIRouter(tags=["orders"])

# Payment method strings that mean payment is collected on delivery.
_CASH_METHODS = {"", "cod", "cash", "cash on delivery", "cash_on_delivery"}


def _buyer_or_seller(order: Order, user: User) -> None:
    """Reject access when the user is neither buyer nor seller of an order."""
    if order.buyer_id != user.id and order.seller_id != user.id:
        raise HTTPException(status_code=403, detail="Not your order")


@router.post("/orders", status_code=201)
def create_order(
    body: OrderCreateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    listing = db.get(Listing, body.listingId)
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")
    if listing.status != "active":
        raise HTTPException(status_code=400, detail="Listing is not available")
    if listing.seller_id == current_user.id:
        raise HTTPException(status_code=400, detail="Cannot buy your own listing")

    order = Order(
        id=generate_id("ord"),
        buyer_id=current_user.id,
        seller_id=listing.seller_id,
        listing_id=listing.id,
        listing_title=listing.title,
        listing_image=listing.images[0] if listing.images else "",
        price=listing.price,
        currency=listing.currency,
        status="pending",
        shipping_address=body.shippingAddress,
        payment_method=body.paymentMethod,
        is_paid=body.paymentMethod.strip().lower() not in _CASH_METHODS,
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
    if listing.seller_id != current_user.id:
        create_notification(
            db,
            user_id=current_user.id,
            title="Order Placed",
            body=f"Your order for {order.listing_title} was placed and is awaiting confirmation.",
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
    role: str | None = Query(None, description="Filter as 'buyer' or 'seller'"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = select(Order)
    if role == "seller":
        query = query.where(Order.seller_id == current_user.id)
    elif role == "buyer":
        query = query.where(Order.buyer_id == current_user.id)
    else:
        query = query.where(
            or_(Order.buyer_id == current_user.id, Order.seller_id == current_user.id)
        )
    if status:
        query = query.where(Order.status == status)
    query = query.order_by(Order.created_at.desc())

    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    return pagination([serialize_order(o) for o in rows], page, limit, total)


@router.get("/orders/{order_id}")
def get_order(
    order_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    order = db.get(Order, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    _buyer_or_seller(order, current_user)
    return serialize_order(order)


@router.post("/orders/{order_id}/cancel")
def cancel_order(
    order_id: str,
    body: OrderCancelRequest | None = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    order = db.get(Order, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    _buyer_or_seller(order, current_user)
    if order.status == "cancelled":
        raise HTTPException(status_code=400, detail="Order already cancelled")
    if order.status == "delivered":
        raise HTTPException(status_code=400, detail="Cannot cancel a delivered order")
    order.status = "cancelled"
    listing = db.get(Listing, order.listing_id)
    if listing and listing.status == "reserved":
        listing.status = "active"
    create_notification(
        db,
        user_id=order.seller_id if order.buyer_id == current_user.id else order.buyer_id,
        title="Order Cancelled",
        body=f"Order for {order.listing_title} was cancelled.",
        type="order",
        data={"orderId": order.id},
    )
    db.commit()
    db.refresh(order)
    return serialize_order(order)


@router.get("/orders/{order_id}/track")
def track_order(
    order_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    order = db.get(Order, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    _buyer_or_seller(order, current_user)

    created = order.created_at
    tracking = [{"status": "Order placed", "date": created.isoformat()}]
    if order.is_paid:
        tracking.append({"status": "Payment confirmed", "date": created.isoformat()})
    else:
        tracking.append({"status": "Payment pending", "date": created.isoformat()})
    if order.status in ("confirmed", "shipped", "delivered"):
        tracking.append({"status": "Seller confirmed", "date": (created + timedelta(hours=12)).isoformat()})
    if order.status in ("shipped", "delivered"):
        tracking.append({"status": "Shipped", "date": (created + timedelta(days=1)).isoformat()})
    if order.status == "delivered":
        tracking.append({"status": "Delivered", "date": (created + timedelta(days=2)).isoformat()})
    if order.status == "cancelled":
        tracking.append({"status": "Cancelled", "date": created.isoformat()})

    estimated_delivery = None
    if order.status in ("pending", "confirmed", "shipped"):
        estimated_delivery = (created + timedelta(days=5)).isoformat()
    return {
        "orderId": order.id,
        "status": order.status,
        "tracking": tracking,
        "estimatedDelivery": estimated_delivery,
    }
