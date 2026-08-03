from datetime import datetime, timedelta

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from ...config import settings
from ...core.database import get_db
from ...models import Order
from ..schemas import OrderCancelRequest
from ..serializers import pagination, serialize_order

router = APIRouter(tags=["orders"])


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
