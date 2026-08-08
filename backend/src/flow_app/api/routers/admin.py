"""Admin endpoints. Role-gated (admin) and require a real Bearer token."""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session

from ...core.database import get_db
from ...core.security import ADMIN_ROLE, require_roles, utcnow
from ...models import Listing, Order, User
from ..schemas import RoleUpdateRequest
from ..serializers import pagination

router = APIRouter(prefix="/admin", tags=["admin"], dependencies=[Depends(require_roles(ADMIN_ROLE))])


def _admin_user_payload(user: User) -> dict:
    return {
        "id": user.id,
        "username": user.username,
        "name": user.name,
        "email": user.email,
        "role": user.role or "user",
        "status": user.status,
        "isVerified": user.is_verified,
        "createdAt": user.created_at.isoformat(),
    }


@router.get("/users")
def get_users(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    search: str | None = None,
    db: Session = Depends(get_db),
):
    query = select(User)
    if search:
        like = f"%{search}%"
        query = query.where(
            or_(User.name.like(like), User.email.like(like), User.username.like(like))
        )
    query = query.order_by(User.created_at.desc())

    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    return pagination([_admin_user_payload(u) for u in rows], page, limit, total)


@router.patch("/users/{user_id}/role")
def update_user_role(user_id: str, body: RoleUpdateRequest, db: Session = Depends(get_db)):
    user = db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.role = body.role
    user.updated_at = utcnow()
    db.commit()
    db.refresh(user)
    return _admin_user_payload(user)


@router.post("/users/{user_id}/suspend")
def suspend_user(user_id: str, db: Session = Depends(get_db)):
    user = db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.status = "suspended"
    user.updated_at = utcnow()
    db.commit()
    return _admin_user_payload(user)


@router.post("/users/{user_id}/activate")
def activate_user(user_id: str, db: Session = Depends(get_db)):
    user = db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.status = "active"
    user.updated_at = utcnow()
    db.commit()
    return _admin_user_payload(user)


@router.get("/stats")
def get_stats(db: Session = Depends(get_db)):
    users = db.scalar(select(func.count()).select_from(User)) or 0
    sellers = (
        db.scalar(
            select(func.count()).select_from(User).where(User.role == "seller")
        )
        or 0
    )
    listings = db.scalar(select(func.count()).select_from(Listing)) or 0
    orders = db.scalar(select(func.count()).select_from(Order)) or 0
    pending_orders = (
        db.scalar(
            select(func.count())
            .select_from(Order)
            .where(Order.status.in_(["pending", "confirmed"]))
        )
        or 0
    )
    revenue = db.scalar(
        select(func.coalesce(func.sum(Order.price * Order.quantity), 0)).where(
            Order.is_paid.is_(True)
        )
    )
    return {
        "users": int(users),
        "sellers": int(sellers),
        "listings": int(listings),
        "orders": int(orders),
        "pendingOrders": int(pending_orders),
        "revenue": float(revenue),
    }
