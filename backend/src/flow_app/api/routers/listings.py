from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session

from ...core.database import get_db
from ...core.security import SELLER_ROLE, get_current_user
from ...core.services import create_notification, generate_id
from ...models import Favorite, Listing, User, UserFollow
from ..schemas import ListingCreateRequest, ListingUpdateRequest
from ..serializers import pagination, serialize_listing

router = APIRouter(tags=["listings"])


def _favorite_by(db: Session, listing_id: str) -> list[str]:
    return list(
        db.scalars(select(Favorite.user_id).where(Favorite.listing_id == listing_id)).all()
    )


def _listing_payload(db: Session, listing: Listing) -> dict:
    return serialize_listing(listing, favorite_by=_favorite_by(db, listing.id))


def _owner_or_admin(listing: Listing, user: User) -> None:
    if listing.seller_id != user.id and user.role != "admin":
        raise HTTPException(status_code=403, detail="Not your listing")


@router.get("/listings")
def get_listings(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    category: str | None = None,
    sortBy: str | None = None,
    sellerId: str | None = None,
    db: Session = Depends(get_db),
):
    query = select(Listing).where(Listing.status != "archived")
    if sellerId:
        query = query.where(Listing.seller_id == sellerId)
    else:
        query = query.where(Listing.status == "active")
    if category:
        query = query.where(Listing.category == category)

    if sortBy == "price_asc":
        query = query.order_by(Listing.price.asc())
    elif sortBy == "price_desc":
        query = query.order_by(Listing.price.desc())
    elif sortBy == "newest":
        query = query.order_by(Listing.created_at.desc())
    else:
        query = query.order_by(Listing.created_at.desc())

    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    items = [_listing_payload(db, l) for l in rows]
    return pagination(items, page, limit, total)


@router.get("/users/me/listings")
def get_my_listings(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    status: str | None = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = select(Listing).where(Listing.seller_id == current_user.id)
    if status:
        query = query.where(Listing.status == status)
    query = query.order_by(Listing.created_at.desc())

    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    items = [_listing_payload(db, l) for l in rows]
    return pagination(items, page, limit, total)


@router.get("/wishlist")
def get_wishlist(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    user_id = current_user.id
    query = (
        select(Listing)
        .join(Favorite, Favorite.listing_id == Listing.id)
        .where(Favorite.user_id == user_id)
        .order_by(Favorite.created_at.desc())
    )

    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    items = [_listing_payload(db, l) for l in rows]
    return pagination(items, page, limit, total)


@router.get("/listings/search")
def search_listings(
    q: str = Query("", alias="q"),
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    query = select(Listing).where(Listing.status == "active")
    if q:
        like = f"%{q}%"
        query = query.where(or_(Listing.title.like(like), Listing.description.like(like)))
    query = query.order_by(Listing.created_at.desc())

    total = len(db.scalars(query).all())
    rows = db.scalars(query.offset((page - 1) * limit).limit(limit)).all()
    items = [_listing_payload(db, l) for l in rows]
    return pagination(items, page, limit, total)


@router.get("/listings/{listing_id}")
def get_listing(listing_id: str, db: Session = Depends(get_db)):
    listing = db.get(Listing, listing_id)
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")
    return _listing_payload(db, listing)


@router.post("/listings", status_code=201)
def create_listing(
    body: ListingCreateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    listing = Listing(
        id=generate_id("list"),
        seller_id=current_user.id,
        title=body.title,
        description=body.description,
        price=body.price,
        images=body.images,
        category=body.category,
        subcategory=body.subcategory,
        item_condition=body.condition,
        location=body.location,
        status="active",
        created_at=func.now(),
    )
    db.add(listing)

    if current_user.role != SELLER_ROLE:
        current_user.role = SELLER_ROLE
        db.flush()

    follower_ids = db.scalars(
        select(UserFollow.follower_id).where(UserFollow.followee_id == current_user.id)
    ).all()
    for follower_id in follower_ids:
        create_notification(
            db,
            user_id=follower_id,
            title="New Listing",
            body=f"{current_user.name} just posted {body.title}.",
            type="listing",
            data={"listingId": listing.id},
        )

    db.commit()
    db.refresh(listing)
    return _listing_payload(db, listing)


@router.put("/listings/{listing_id}")
def update_listing(
    listing_id: str,
    body: ListingUpdateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    listing = db.get(Listing, listing_id)
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")
    _owner_or_admin(listing, current_user)

    updates = body.model_dump(exclude_unset=True)
    field_map = {
        "condition": "item_condition",
    }
    for key, value in updates.items():
        if value is None:
            continue
        column = field_map.get(key, key)
        setattr(listing, column, value)
    db.commit()
    db.refresh(listing)
    return _listing_payload(db, listing)


@router.delete("/listings/{listing_id}")
def delete_listing(
    listing_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    listing = db.get(Listing, listing_id)
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")
    _owner_or_admin(listing, current_user)
    if listing.status == "archived":
        raise HTTPException(status_code=400, detail="Listing already archived")
    listing.status = "archived"
    db.commit()
    return {"ok": True}


@router.post("/listings/{listing_id}/favorite")
def toggle_favorite(
    listing_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    listing = db.get(Listing, listing_id)
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")

    user_id = current_user.id
    existing = db.get(Favorite, (user_id, listing_id))
    if existing:
        db.delete(existing)
        favorited = False
    else:
        db.add(Favorite(user_id=user_id, listing_id=listing_id))
        favorited = True
        if listing.seller_id != user_id:
            create_notification(
                db,
                user_id=listing.seller_id,
                title="New Favorite",
                body=f"{current_user.name} saved your listing {listing.title}.",
                type="favorite",
                data={"listingId": listing_id},
            )

    db.flush()
    favorite_count = db.scalar(
        select(func.count()).select_from(Favorite).where(Favorite.listing_id == listing_id)
    )
    listing.favorite_count = favorite_count
    db.commit()
    return {"favorited": favorited, "favoriteCount": favorite_count}
