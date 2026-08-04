from pathlib import Path

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import delete, select

from flow_app.config import settings
from flow_app.core.database import SessionLocal
from flow_app.main import app
from flow_app.models import (
    Conversation,
    Favorite,
    Listing,
    Message,
    Notification,
    Order,
    Review,
    User,
)


@pytest.fixture()
def client():
    with TestClient(app) as test_client:
        yield test_client


@pytest.fixture()
def clean_db():
    """Snapshot DB state before a test and restore it afterwards.

    Keeps tests idempotent against the shared seeded dev database: rows
    created during the test are removed and mutated columns (listing status,
    favorite count, seller rating) are restored.
    """
    db = SessionLocal()
    baseline = {
        "listings": {
            l.id: (l.status, l.favorite_count) for l in db.scalars(select(Listing)).all()
        },
        "listing_ids": set(db.scalars(select(Listing.id)).all()),
        "users": {
            u.id: (u.rating, u.reviews_count) for u in db.scalars(select(User)).all()
        },
        "orders": set(db.scalars(select(Order.id)).all()),
        "conversations": set(db.scalars(select(Conversation.id)).all()),
        "messages": set(db.scalars(select(Message.id)).all()),
        "notifications": set(db.scalars(select(Notification.id)).all()),
        "reviews": set(db.scalars(select(Review.id)).all()),
        "favorites": {(f.user_id, f.listing_id) for f in db.scalars(select(Favorite)).all()},
    }
    upload_dir = Path(settings.upload_dir).resolve()
    baseline_files = set(upload_dir.iterdir()) if upload_dir.exists() else set()
    db.close()
    yield
    db = SessionLocal()
    try:
        if baseline["messages"]:
            db.execute(delete(Message).where(Message.id.not_in(baseline["messages"])))
        if baseline["conversations"]:
            db.execute(
                delete(Conversation).where(
                    Conversation.id.not_in(baseline["conversations"])
                )
            )
        if baseline["reviews"]:
            db.execute(delete(Review).where(Review.id.not_in(baseline["reviews"])))
        if baseline["notifications"]:
            db.execute(
                delete(Notification).where(
                    Notification.id.not_in(baseline["notifications"])
                )
            )
        if baseline["orders"]:
            db.execute(delete(Order).where(Order.id.not_in(baseline["orders"])))
        for fav in db.scalars(select(Favorite)).all():
            if (fav.user_id, fav.listing_id) not in baseline["favorites"]:
                db.delete(fav)
        for lid, (status, favorite_count) in baseline["listings"].items():
            listing = db.get(Listing, lid)
            if listing and (listing.status, listing.favorite_count) != (status, favorite_count):
                listing.status = status
                listing.favorite_count = favorite_count
        for uid, (rating, reviews_count) in baseline["users"].items():
            user = db.get(User, uid)
            if user and (user.rating, user.reviews_count) != (rating, reviews_count):
                user.rating = rating
                user.reviews_count = reviews_count
        for lid in set(db.scalars(select(Listing.id)).all()) - baseline["listing_ids"]:
            db.delete(db.get(Listing, lid))
        db.commit()
        for file in set(upload_dir.iterdir()) - baseline_files if upload_dir.exists() else []:
            file.unlink()
    finally:
        db.close()
