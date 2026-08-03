from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from ...config import settings
from ...core.database import get_db
from ...models import Notification
from ..serializers import pagination, serialize_notification

router = APIRouter(tags=["notifications"])


@router.get("/notifications")
def get_notifications(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    query = (
        select(Notification)
        .where(Notification.user_id == settings.current_user_id)
        .order_by(Notification.created_at.desc())
    )
    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    return pagination([serialize_notification(n) for n in rows], page, limit, total)


@router.post("/notifications/{notif_id}/read")
def mark_read(notif_id: str, db: Session = Depends(get_db)):
    notif = db.get(Notification, notif_id)
    if not notif:
        raise HTTPException(status_code=404, detail="Notification not found")
    notif.is_read = True
    db.commit()
    return {"ok": True}


@router.post("/notifications/read-all")
def mark_all_read(db: Session = Depends(get_db)):
    rows = db.scalars(
        select(Notification).where(
            Notification.user_id == settings.current_user_id,
            Notification.is_read.is_(False),
        )
    ).all()
    for notif in rows:
        notif.is_read = True
    db.commit()
    return {"ok": True}


@router.get("/notifications/unread-count")
def get_notifications_unread_count(db: Session = Depends(get_db)):
    count = db.scalar(
        select(func.count()).select_from(Notification).where(
            Notification.user_id == settings.current_user_id,
            Notification.is_read.is_(False),
        )
    )
    return {"count": int(count)}
