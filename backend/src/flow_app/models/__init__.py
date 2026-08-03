"""SQLAlchemy ORM models matching db/schema.sql."""
from datetime import datetime

from sqlalchemy import (
    JSON,
    Boolean,
    DateTime,
    ForeignKey,
    Integer,
    Numeric,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column

from ..core.database import Base


class User(Base):
    __tablename__ = "flow_users"

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    name: Mapped[str] = mapped_column(String(255))
    email: Mapped[str] = mapped_column(String(255), unique=True)
    phone: Mapped[str] = mapped_column(String(32), default="")
    avatar_url: Mapped[str] = mapped_column(String(1024), default="")
    is_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    location: Mapped[str] = mapped_column(String(255), default="")
    rating: Mapped[float] = mapped_column(Numeric(3, 2), default=0)
    reviews_count: Mapped[int] = mapped_column(Integer, default=0)
    listings_count: Mapped[int] = mapped_column(Integer, default=0)
    sales_count: Mapped[int] = mapped_column(Integer, default=0)
    bio: Mapped[str | None] = mapped_column(Text, nullable=True)
    member_duration: Mapped[str] = mapped_column(String(64), default="")
    positive_percent: Mapped[float] = mapped_column(Numeric(5, 2), default=0)
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())


class UserFollow(Base):
    __tablename__ = "flow_user_follows"
    __table_args__ = (
        UniqueConstraint("follower_id", "followee_id", name="uq_follow_pair"),
    )

    follower_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    followee_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())


class Category(Base):
    __tablename__ = "flow_categories"

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    name: Mapped[str] = mapped_column(String(64))
    icon: Mapped[str] = mapped_column(String(64), default="other")
    count: Mapped[int] = mapped_column(Integer, default=0)


class Listing(Base):
    __tablename__ = "flow_listings"

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    seller_id: Mapped[str] = mapped_column(ForeignKey("flow_users.id"))
    title: Mapped[str] = mapped_column(String(255), default="")
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    price: Mapped[float] = mapped_column(Numeric(12, 2), default=0)
    currency: Mapped[str] = mapped_column(String(8), default="NGN")
    images: Mapped[list] = mapped_column(JSON, default=list)
    category: Mapped[str] = mapped_column(String(64), default="")
    subcategory: Mapped[str] = mapped_column(String(64), default="")
    status: Mapped[str] = mapped_column(String(16), default="active")
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
    is_featured: Mapped[bool] = mapped_column(Boolean, default=False)
    view_count: Mapped[int] = mapped_column(Integer, default=0)
    favorite_count: Mapped[int] = mapped_column(Integer, default=0)
    item_condition: Mapped[str] = mapped_column(String(32), default="")
    location: Mapped[str] = mapped_column(String(255), default="")


class Favorite(Base):
    __tablename__ = "flow_favorites"
    __table_args__ = (
        UniqueConstraint("user_id", "listing_id", name="uq_fav_pair"),
    )

    user_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    listing_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())


class Order(Base):
    __tablename__ = "flow_orders"

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    buyer_id: Mapped[str] = mapped_column(ForeignKey("flow_users.id"))
    seller_id: Mapped[str] = mapped_column(ForeignKey("flow_users.id"))
    listing_id: Mapped[str] = mapped_column(ForeignKey("flow_listings.id"))
    listing_title: Mapped[str] = mapped_column(String(255), default="")
    listing_image: Mapped[str] = mapped_column(String(1024), default="")
    price: Mapped[float] = mapped_column(Numeric(12, 2), default=0)
    currency: Mapped[str] = mapped_column(String(8), default="NGN")
    status: Mapped[str] = mapped_column(String(16), default="pending")
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
    shipping_address: Mapped[str] = mapped_column(String(512), default="")
    payment_method: Mapped[str] = mapped_column(String(64), default="")
    is_paid: Mapped[bool] = mapped_column(Boolean, default=False)
    quantity: Mapped[int] = mapped_column(Integer, default=1)


class Conversation(Base):
    __tablename__ = "flow_conversations"
    __table_args__ = (
        UniqueConstraint("user_a_id", "user_b_id", name="uq_conv_pair"),
    )

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    user_a_id: Mapped[str] = mapped_column(ForeignKey("flow_users.id"))
    user_b_id: Mapped[str] = mapped_column(ForeignKey("flow_users.id"))
    last_message: Mapped[str | None] = mapped_column(Text, nullable=True)
    last_message_time: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
    unread_count: Mapped[int] = mapped_column(Integer, default=0)
    is_online: Mapped[bool] = mapped_column(Boolean, default=False)
    product_title: Mapped[str] = mapped_column(String(255), default="")
    product_image: Mapped[str] = mapped_column(String(1024), default="")
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())


class Message(Base):
    __tablename__ = "flow_messages"

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    conversation_id: Mapped[str] = mapped_column(ForeignKey("flow_conversations.id"))
    sender_id: Mapped[str] = mapped_column(ForeignKey("flow_users.id"))
    text: Mapped[str | None] = mapped_column(Text, nullable=True)
    image_url: Mapped[str] = mapped_column(String(1024), default="")
    timestamp: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
    is_read: Mapped[bool] = mapped_column(Boolean, default=False)


class Review(Base):
    __tablename__ = "flow_reviews"

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    seller_id: Mapped[str] = mapped_column(ForeignKey("flow_users.id"))
    reviewer_id: Mapped[str | None] = mapped_column(String(64), nullable=True)
    user_name: Mapped[str] = mapped_column(String(255), default="")
    user_avatar: Mapped[str] = mapped_column(String(1024), default="")
    rating: Mapped[int] = mapped_column(Integer, default=5)
    date: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
    text: Mapped[str | None] = mapped_column(Text, nullable=True)
    has_photo: Mapped[bool] = mapped_column(Boolean, default=False)
    photo_url: Mapped[str] = mapped_column(String(1024), default="")


class Notification(Base):
    __tablename__ = "flow_notifications"

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    user_id: Mapped[str] = mapped_column(ForeignKey("flow_users.id"))
    title: Mapped[str] = mapped_column(String(255), default="")
    body: Mapped[str | None] = mapped_column(Text, nullable=True)
    type: Mapped[str] = mapped_column(String(16), default="system")
    is_read: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
    data: Mapped[dict | None] = mapped_column(JSON, nullable=True)
