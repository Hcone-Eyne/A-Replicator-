from sqlalchemy import select

from flow_app.core.database import SessionLocal
from flow_app.models import Notification


def test_listings_filter_by_seller(client, clean_db):
    r = client.get("/listings?sellerId=user_002")
    assert r.status_code == 200
    data = r.json()
    assert data["totalItems"] >= 1
    assert all(i["sellerId"] == "user_002" for i in data["items"])


def test_listings_by_seller_includes_inactive(client, clean_db):
    client.post("/orders", json={"listingId": "list_001"})
    r = client.get("/listings?sellerId=user_002")
    data = r.json()
    assert any(i["id"] == "list_001" for i in data["items"])


def test_my_listings(client, clean_db):
    r = client.get("/users/me/listings")
    assert r.status_code == 200
    data = r.json()
    assert data["totalItems"] == 1
    assert data["items"][0]["id"] == "list_010"


def test_my_listings_status_filter(client, clean_db):
    r = client.get("/users/me/listings?status=active")
    assert r.status_code == 200
    assert r.json()["totalItems"] == 1


def test_create_listing_shows_in_my_listings(client, clean_db):
    r = client.post(
        "/listings",
        json={
            "title": "Test Item",
            "price": 100,
            "category": "electronics",
            "condition": "new",
            "location": "Lagos",
            "images": [],
        },
    )
    assert r.status_code == 201
    lid = r.json()["id"]
    mine = client.get("/users/me/listings").json()
    assert any(i["id"] == lid for i in mine["items"])


def test_wishlist_reflects_favorite_toggle(client, clean_db):
    client.post("/listings/list_005/favorite")
    r = client.get("/wishlist")
    assert r.status_code == 200
    data = r.json()
    assert "items" in data and "totalPages" in data
    assert any(i["id"] == "list_005" for i in data["items"])


def test_create_order(client, clean_db):
    r = client.post(
        "/orders",
        json={
            "listingId": "list_001",
            "quantity": 1,
            "shippingAddress": "Lagos",
            "paymentMethod": "card",
        },
    )
    assert r.status_code == 201
    order = r.json()
    assert order["listingId"] == "list_001"
    assert order["sellerId"] == "user_002"
    assert order["buyerId"] == "user_001"
    assert order["status"] == "pending"
    assert order["isPaid"] is True
    listing = client.get("/listings/list_001").json()
    assert listing["status"] == "reserved"


def test_create_order_creates_seller_notification(client, clean_db):
    client.post(
        "/orders",
        json={"listingId": "list_001", "shippingAddress": "Lagos", "paymentMethod": "card"},
    )
    db = SessionLocal()
    try:
        notifs = db.scalars(
            select(Notification).where(Notification.user_id == "user_002")
        ).all()
        assert any(n.type == "order" for n in notifs)
    finally:
        db.close()


def test_create_order_own_listing_rejected(client, clean_db):
    r = client.post("/orders", json={"listingId": "list_010"})
    assert r.status_code == 400


def test_create_order_missing_listing(client, clean_db):
    r = client.post("/orders", json={"listingId": "list_nope"})
    assert r.status_code == 404


def test_create_order_not_available(client, clean_db):
    client.post("/orders", json={"listingId": "list_001"})
    r = client.post("/orders", json={"listingId": "list_001"})
    assert r.status_code == 400


def test_create_conversation(client, clean_db):
    r = client.post(
        "/conversations",
        json={
            "otherUserId": "user_005",
            "productId": "list_004",
            "productTitle": "Sneakers",
            "initialMessage": "Hi, is this available?",
        },
    )
    assert r.status_code == 201
    conv = r.json()
    assert conv["otherUserId"] == "user_005"
    assert conv["lastMessage"] == "Hi, is this available?"


def test_create_conversation_dedupes(client, clean_db):
    r1 = client.post(
        "/conversations", json={"otherUserId": "user_005", "initialMessage": "hello"}
    )
    r2 = client.post(
        "/conversations", json={"otherUserId": "user_005", "initialMessage": "again"}
    )
    assert r1.status_code == 201 and r2.status_code == 201
    assert r1.json()["id"] == r2.json()["id"]


def test_cannot_chat_with_self(client, clean_db):
    r = client.post("/conversations", json={"otherUserId": "user_001"})
    assert r.status_code == 400


def test_send_message_updates_unread_count(client, clean_db):
    conv = client.post("/conversations", json={"otherUserId": "user_005"}).json()
    conv_id = conv["id"]
    assert conv["unreadCount"] == 0
    r = client.post(f"/conversations/{conv_id}/messages", json={"text": "Hi there"})
    assert r.status_code == 201
    convs = client.get("/conversations").json()
    updated = next(c for c in convs if c["id"] == conv_id)
    assert updated["unreadCount"] == 1


def test_create_review(client, clean_db):
    r = client.post(
        "/sellers/user_005/reviews", json={"rating": 5, "text": "Great seller"}
    )
    assert r.status_code == 201
    review = r.json()
    assert review["sellerId"] == "user_005"
    assert review["rating"] == 5
    seller = client.get("/sellers/user_005").json()
    assert seller["rating"] == 5.0
    reviews = client.get("/sellers/user_005/reviews").json()
    assert any(r["id"] == review["id"] for r in reviews)


def test_create_review_invalid_rating(client, clean_db):
    r = client.post("/sellers/user_005/reviews", json={"rating": 6})
    assert r.status_code == 400


def test_upload_image(client, clean_db):
    r = client.post(
        "/upload",
        files={"file": ("test.png", b"\x89PNG\r\n\x1a\n", "image/png")},
    )
    assert r.status_code == 201
    data = r.json()
    assert data["url"].startswith("/uploads/")
    assert data["name"].endswith(".png")
    served = client.get(data["url"])
    assert served.status_code == 200


def test_upload_rejects_bad_type(client, clean_db):
    r = client.post(
        "/upload",
        files={"file": ("bad.txt", b"hello", "text/plain")},
    )
    assert r.status_code == 400
