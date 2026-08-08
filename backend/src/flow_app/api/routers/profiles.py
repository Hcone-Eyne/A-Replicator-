from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from ...core.database import get_db
from ...core.security import get_current_user
from ...core.services import create_notification, generate_id, user_payload
from ...models import Listing, Order, Review, User, UserFollow
from ..schemas import ProfileUpdateRequest, ReviewCreateRequest
from ..serializers import serialize_review, serialize_seller

router = APIRouter(tags=["profiles"])


@router.get("/profile")
def get_profile(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return user_payload(db, current_user, current_user.id)


@router.put("/profile")
def update_profile(
    body: ProfileUpdateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    user = current_user
    updates = body.model_dump(exclude_unset=True)
    field_map = {"avatarUrl": "avatar_url"}
    for key, value in updates.items():
        if value is not None:
            setattr(user, field_map.get(key, key), value)
    db.commit()
    db.refresh(user)
    return user_payload(db, user, user.id)


@router.get("/sellers/{seller_id}")
def get_seller(seller_id: str, db: Session = Depends(get_db)):
    user = db.get(User, seller_id)
    if not user:
        raise HTTPException(status_code=404, detail="Seller not found")

    sales_count = db.scalar(
        select(func.count()).select_from(Order).where(Order.seller_id == seller_id)
    ) or 0
    listings_count = db.scalar(
        select(func.count()).select_from(Listing).where(Listing.seller_id == seller_id)
    ) or 0
    rating = db.scalar(
        select(func.avg(Review.rating)).where(Review.seller_id == seller_id)
    ) or user.rating

    return serialize_seller(
        user,
        sales_count=sales_count,
        listings_count=listings_count,
        rating=float(rating),
        positive_percent=user.positive_percent,
    )


@router.post("/sellers/{seller_id}/follow")
def follow_seller(
    seller_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    user_id = current_user.id
    if user_id == seller_id:
        raise HTTPException(status_code=400, detail="Cannot follow yourself")
    followee = db.get(User, seller_id)
    if not followee:
        raise HTTPException(status_code=404, detail="Seller not found")
    if db.get(UserFollow, (user_id, seller_id)):
        return {"ok": True, "alreadyFollowing": True}
    db.add(UserFollow(follower_id=user_id, followee_id=seller_id))
    create_notification(
        db,
        user_id=seller_id,
        title="New Follower",
        body=f"{current_user.name} started following you.",
        type="follow",
        data={"userId": user_id},
    )
    db.commit()
    return {"ok": True, "alreadyFollowing": False}


@router.delete("/sellers/{seller_id}/follow")
def unfollow_seller(
    seller_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    user_id = current_user.id
    row = db.get(UserFollow, (user_id, seller_id))
    if row:
        db.delete(row)
        db.commit()
    return {"ok": True}


@router.get("/sellers/{seller_id}/reviews")
def get_reviews(
    seller_id: str,
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    query = (
        select(Review)
        .where(Review.seller_id == seller_id)
        .order_by(Review.date.desc())
    )
    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    return [serialize_review(r) for r in rows]


@router.post("/sellers/{seller_id}/reviews", status_code=201)
def create_review(
    seller_id: str,
    body: ReviewCreateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    seller = db.get(User, seller_id)
    if not seller:
        raise HTTPException(status_code=404, detail="Seller not found")
    if not 1 <= body.rating <= 5:
        raise HTTPException(status_code=400, detail="Rating must be between 1 and 5")
    if seller_id == current_user.id:
        raise HTTPException(status_code=400, detail="Cannot review yourself")

    existing = db.scalar(
        select(Review.id).where(
            Review.seller_id == seller_id,
            Review.reviewer_id == current_user.id,
        )
    )
    if existing:
        raise HTTPException(status_code=400, detail="You have already reviewed this seller")

    review = Review(
        id=generate_id("rev"),
        seller_id=seller_id,
        reviewer_id=current_user.id,
        user_name=current_user.name,
        user_avatar=current_user.avatar_url,
        rating=body.rating,
        text=body.text,
        has_photo=body.hasPhoto,
        photo_url=body.photoUrl,
    )
    db.add(review)
    db.flush()

    avg = db.scalar(
        select(func.avg(Review.rating)).where(Review.seller_id == seller_id)
    )
    count = db.scalar(
        select(func.count()).select_from(Review).where(Review.seller_id == seller_id)
    )
    positive_count = db.scalar(
        select(func.count()).select_from(Review).where(
            Review.seller_id == seller_id,
            Review.rating >= 4,
        )
    )
    seller.rating = float(avg) or 0
    seller.reviews_count = int(count or 0)
    seller.positive_percent = round((positive_count or 0) * 100 / max(int(count or 0), 1), 2)
    create_notification(
        db,
        user_id=seller_id,
        title="New Review",
        body=f"{current_user.name} left you a {body.rating}-star review.",
        type="review",
        data={"reviewId": review.id},
    )
    db.commit()
    db.refresh(review)
    return serialize_review(review)
