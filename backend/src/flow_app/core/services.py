"""Shared service helpers for routers."""
from sqlalchemy import select
from sqlalchemy.orm import Session

from ..api import serializers
from ..models import Favorite, Listing, User, UserFollow


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
