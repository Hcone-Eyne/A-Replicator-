"""Shared service helpers for routers."""
import secrets
import time

from sqlalchemy import select
from sqlalchemy.orm import Session

from ..api import serializers
from ..models import Favorite, Listing, Notification, User, UserFollow


def generate_id(prefix: str) -> str:
    """Create a collision-resistant id for a record (ms timestamp + random suffix)."""
    return f"{prefix}_{int(time.time() * 1000)}_{secrets.token_hex(3)}"


def create_notification(
    db: Session,
    user_id: str,
    title: str,
    body: str = "",
    type: str = "system",
    data: dict | None = None,
) -> Notification:
    """Persist a notification for a user. Caller is responsible for commit."""
    notification = Notification(
        id=f"notif_{int(time.time() * 1000)}_{secrets.token_hex(3)}",
        user_id=user_id,
        title=title,
        body=body,
        type=type,
        data=data or {},
    )
    db.add(notification)
    return notification


def user_payload(db: Session, user: User, current_user_id: str) -> dict:
    followers = db.scalars(
        select(UserFollow.follower_id).where(UserFollow.followee_id == user.id)
    ).all()
    following = db.scalars(
        select(UserFollow.followee_id).where(UserFollow.follower_id == user.id)
    ).all()
    is_following = (
        db.execute(
            select(UserFollow.follower_id).where(
                UserFollow.follower_id == current_user_id,
                UserFollow.followee_id == user.id,
            )
        ).first()
        is not None
    )
    listing_ids = db.scalars(
        select(Listing.id).where(Listing.seller_id == user.id)
    ).all()
    wishlist_ids = db.scalars(
        select(Favorite.listing_id).where(Favorite.user_id == user.id)
    ).all()

    return serializers.serialize_user(
        user,
        followers=list(followers),
        following=list(following),
        is_following=is_following,
        listing_ids=list(listing_ids),
        wishlist_ids=list(wishlist_ids),
    )
