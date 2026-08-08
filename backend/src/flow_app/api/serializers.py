"""Response serializers.

Produce dicts whose keys exactly match the Dart freezed models'
JSON field names (lib/features/*/data/models/).
"""
import hashlib

from ..models import User

_COLOR_PALETTE = [
    "#2196F3",
    "#4CAF50",
    "#FF9800",
    "#9C27B0",
    "#F44336",
    "#00BCD4",
    "#FFC107",
    "#795548",
]


def to_float(value) -> float:
    return float(value) if value is not None else 0.0


def to_bool(value) -> bool:
    return bool(value) if value is not None else False


def to_str_list(value) -> list[str]:
    return list(value) if value else []


def avatar_color(user_id: str) -> str:
    digest = hashlib.md5(user_id.encode("utf-8")).digest()
    return _COLOR_PALETTE[digest[0] % len(_COLOR_PALETTE)]


def initials(name: str) -> str:
    parts = name.split()
    if len(parts) >= 2:
        return (parts[0][0] + parts[1][0]).upper()
    return name[:2].upper() if name else "?"


def pagination(items: list, page: int, limit: int, total: int) -> dict:
    import math

    total_pages = max(1, math.ceil(total / limit)) if total else 1
    return {
        "items": items,
        "page": page,
        "totalPages": total_pages,
        "totalItems": total,
        "hasMore": page < total_pages,
    }


def serialize_user(
    user: User,
    followers: list[str],
    following: list[str],
    is_following: bool,
    listing_ids: list[str],
    wishlist_ids: list[str],
) -> dict:
    return {
        "id": user.id,
        "username": user.username,
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
        "avatarUrl": user.avatar_url,
        "isVerified": to_bool(user.is_verified),
        "location": user.location,
        "role": user.role or "user",
        "rating": to_float(user.rating),
        "reviewsCount": user.reviews_count,
        "listingsCount": user.listings_count,
        "salesCount": user.sales_count,
        "followers": followers,
        "following": following,
        "isFollowing": is_following,
        "listingIds": listing_ids,
        "wishlistIds": wishlist_ids,
    }


def serialize_listing(listing, favorite_by: list[str] | None = None) -> dict:
    return {
        "id": listing.id,
        "sellerId": listing.seller_id,
        "title": listing.title,
        "description": listing.description or "",
        "price": to_float(listing.price),
        "currency": listing.currency,
        "images": to_str_list(listing.images),
        "category": listing.category,
        "subcategory": listing.subcategory,
        "status": listing.status,
        "createdAt": listing.created_at.isoformat(),
        "isFeatured": to_bool(listing.is_featured),
        "viewCount": listing.view_count,
        "favoriteCount": listing.favorite_count,
        "favoriteBy": favorite_by if favorite_by is not None else [],
        "condition": listing.item_condition,
        "location": listing.location,
    }


def serialize_category(category) -> dict:
    return {
        "id": category.id,
        "name": category.name,
        "icon": category.icon,
        "count": category.count,
    }


def serialize_seller(
    user: User,
    sales_count: int,
    listings_count: int,
    rating: float,
    positive_percent: float,
) -> dict:
    return {
        "id": user.id,
        "name": user.name,
        "avatarUrl": user.avatar_url,
        "isVerified": to_bool(user.is_verified),
        "rating": to_float(rating),
        "salesCount": sales_count,
        "positivePercent": to_float(positive_percent),
        "memberDuration": user.member_duration,
        "bio": user.bio or "",
        "listingsCount": listings_count,
    }


def serialize_review(review) -> dict:
    return {
        "id": review.id,
        "sellerId": review.seller_id,
        "userName": review.user_name,
        "userAvatar": review.user_avatar,
        "rating": review.rating,
        "date": review.date.isoformat(),
        "text": review.text or "",
        "hasPhoto": to_bool(review.has_photo),
        "photoUrl": review.photo_url,
    }


def serialize_order(order) -> dict:
    return {
        "id": order.id,
        "buyerId": order.buyer_id,
        "sellerId": order.seller_id,
        "listingId": order.listing_id,
        "listingTitle": order.listing_title,
        "listingImage": order.listing_image,
        "price": to_float(order.price),
        "currency": order.currency,
        "status": order.status,
        "createdAt": order.created_at.isoformat(),
        "shippingAddress": order.shipping_address,
        "paymentMethod": order.payment_method,
        "isPaid": to_bool(order.is_paid),
        "quantity": order.quantity,
    }


def serialize_conversation(conversation, other: User, reader_id: str) -> dict:
    unread = (
        conversation.user_a_unread
        if conversation.user_a_id == reader_id
        else conversation.user_b_unread
    )
    return {
        "id": conversation.id,
        "otherUserId": other.id,
        "otherUserName": other.name,
        "otherUserAvatar": other.avatar_url,
        "otherUserInitials": initials(other.name),
        "otherUserAvatarColorHex": avatar_color(other.id),
        "lastMessage": conversation.last_message or "",
        "lastMessageTime": conversation.last_message_time.isoformat(),
        "unreadCount": unread,
        "isOnline": to_bool(conversation.is_online),
        "isVerified": to_bool(other.is_verified),
        "productTitle": conversation.product_title,
        "productImage": conversation.product_image,
    }


def serialize_message(message) -> dict:
    return {
        "id": message.id,
        "conversationId": message.conversation_id,
        "senderId": message.sender_id,
        "text": message.text or "",
        "imageUrl": message.image_url,
        "timestamp": message.timestamp.isoformat(),
        "isRead": to_bool(message.is_read),
    }


def serialize_notification(notification) -> dict:
    return {
        "id": notification.id,
        "title": notification.title,
        "body": notification.body or "",
        "type": notification.type,
        "isRead": to_bool(notification.is_read),
        "createdAt": notification.created_at.isoformat(),
        "data": notification.data or {},
    }
