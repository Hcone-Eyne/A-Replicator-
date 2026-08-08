from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from ...core.database import get_db
from ...core.security import get_current_user
from ...models import Notification, User
from ..serializers import pagination, serialize_notification

router = APIRouter(tags=["notifications"])


@router.get("/notifications")
def get_notifications(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = (
        select(Notification)
        .where(Notification.user_id == current_user.id)
        .order_by(Notification.created_at.desc())
    )
    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    return pagination([serialize_notification(n) for n in rows], page, limit, total)


@router.post("/notifications/{notif_id}/read")
def mark_read(
    notif_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    notif = db.get(Notification, notif_id)
    if not notif:
        raise HTTPException(status_code=404, detail="Notification not found")
    if notif.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not your notification")
    notif.is_read = True
    db.commit()
    return {"ok": True}


@router.post("/notifications/read-all")
def mark_all_read(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    rows = db.scalars(
        select(Notification).where(
            Notification.user_id == current_user.id,
            Notification.is_read.is_(False),
        )
    ).all()
    for notif in rows:
        notif.is_read = True
    db.commit()
    return {"ok": True}


@router.get("/notifications/unread-count")
def get_notifications_unread_count(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    count = db.scalar(
        select(func.count()).select_from(Notification).where(
            Notification.user_id == current_user.id,
            Notification.is_read.is_(False),
        )
    )
    return {"count": int(count)}
