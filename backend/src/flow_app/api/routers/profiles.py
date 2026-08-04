from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from ...config import settings
from ...core.database import get_db
from ...core.services import user_payload
from ...models import Listing, Order, Review, User, UserFollow
from ..schemas import ProfileUpdateRequest, ReviewCreateRequest
from ..serializers import serialize_review, serialize_seller

router = APIRouter(tags=["profiles"])


@router.get("/profile")
def get_profile(db: Session = Depends(get_db)):
    user_id = settings.current_user_id
    user = db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user_payload(db, user, user_id)


@router.put("/profile")
def update_profile(body: ProfileUpdateRequest, db: Session = Depends(get_db)):
    user_id = settings.current_user_id
    user = db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    updates = body.model_dump(exclude_unset=True)
    for key, value in updates.items():
        if value is not None:
            setattr(user, key, value)
    db.commit()
    db.refresh(user)
    return user_payload(db, user, user_id)


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
def follow_seller(seller_id: str, db: Session = Depends(get_db)):
    user_id = settings.current_user_id
    if not db.get(User, seller_id):
        raise HTTPException(status_code=404, detail="Seller not found")
    db.merge(UserFollow(follower_id=user_id, followee_id=seller_id))
    db.commit()
    return {"ok": True}


@router.delete("/sellers/{seller_id}/follow")
def unfollow_seller(seller_id: str, db: Session = Depends(get_db)):
    user_id = settings.current_user_id
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
):
    import time

    seller = db.get(User, seller_id)
    if not seller:
        raise HTTPException(status_code=404, detail="Seller not found")
    if not 1 <= body.rating <= 5:
        raise HTTPException(status_code=400, detail="Rating must be between 1 and 5")

    reviewer = db.get(User, settings.current_user_id)
    review = Review(
        id=f"rev_{int(time.time() * 1000)}",
        seller_id=seller_id,
        reviewer_id=settings.current_user_id,
        user_name=reviewer.name if reviewer else "",
        user_avatar=reviewer.avatar_url if reviewer else "",
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
    seller.rating = float(avg) or 0
    seller.reviews_count = int(count or 0)
    db.commit()
    db.refresh(review)
    return serialize_review(review)
