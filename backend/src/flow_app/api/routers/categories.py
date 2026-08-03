from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from ...core.database import get_db
from ...models import Category
from ..serializers import serialize_category

router = APIRouter(tags=["categories"])


@router.get("/categories")
def get_categories(db: Session = Depends(get_db)):
    rows = db.scalars(select(Category).order_by(Category.id)).all()
    return [serialize_category(c) for c in rows]
