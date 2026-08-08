from sqlalchemy import select

from flow_app.core.database import SessionLocal
from flow_app.models import Notification, User


def _register(client, **overrides):
    payload = {
        "name": "Test User",
        "email": "test@example.com",
        "password": "StrongPass1",
        **overrides,
    }
    return client.post("/auth/register", json=payload)


def _auth(user):
    return {"Authorization": f"Bearer {user['accessToken']}"}


class TestOrderValidation:
    def test_order_quantity_zero_rejected(self, client, clean_db):
        r = client.post(
            "/orders", json={"listingId": "list_001", "quantity": 0}
        )
        assert r.status_code == 422

    def test_order_creates_buyer_notification(self, client, clean_db):
        client.post(
            "/orders",
            json={"listingId": "list_001", "shippingAddress": "Lagos", "paymentMethod": "card"},
        )
        db = SessionLocal()
        try:
            notifs = db.scalars(
                select(Notification).where(Notification.user_id == "user_001")
            ).all()
            assert any(n.type == "order" for n in notifs)
        finally:
            db.close()

    def test_cancel_order_notifies_other_party(self, client, clean_db):
        order = client.post(
            "/orders", json={"listingId": "list_001", "paymentMethod": "card"}
        ).json()
        client.post(f"/orders/{order['id']}/cancel")
        db = SessionLocal()
        try:
            notifs = db.scalars(
                select(Notification).where(Notification.user_id == "user_002")
            ).all()
            assert any(n.type == "order" and "Cancelled" in n.title for n in notifs)
        finally:
            db.close()

    def test_get_order_requires_participation(self, client, clean_db):
        reg = _register(client).json()
        r = client.get("/orders/ord_001", headers=_auth(reg))
        assert r.status_code == 403


class TestReviewValidation:
    def test_cannot_review_self(self, client, clean_db):
        r = client.post("/sellers/user_001/reviews", json={"rating": 5})
        assert r.status_code == 400

    def test_duplicate_review_rejected(self, client, clean_db):
        body = {"rating": 5, "text": "Great seller"}
        assert client.post("/sellers/user_005/reviews", json=body).status_code == 201
        r = client.post("/sellers/user_005/reviews", json=body)
        assert r.status_code == 400

    def test_review_notifies_seller(self, client, clean_db):
        client.post("/sellers/user_005/reviews", json={"rating": 4})
        db = SessionLocal()
        try:
            notifs = db.scalars(
                select(Notification).where(Notification.user_id == "user_005")
            ).all()
            assert any(n.type == "review" for n in notifs)
        finally:
            db.close()


class TestConversationValidation:
    def test_conversation_missing_product_rejected(self, client, clean_db):
        r = client.post(
            "/conversations",
            json={"otherUserId": "user_005", "productId": "list_nope"},
        )
        assert r.status_code == 404

    def test_conversation_fills_product_from_listing(self, client, clean_db):
        r = client.post(
            "/conversations",
            json={"otherUserId": "user_002", "productId": "list_001"},
        )
        assert r.status_code == 201
        assert r.json()["productTitle"] == "iPhone 15 Pro Max 256GB"

    def test_messages_require_participant(self, client, clean_db):
        reg = _register(client).json()
        r = client.get("/conversations/conv_001/messages", headers=_auth(reg))
        assert r.status_code == 403

    def test_send_message_requires_participant(self, client, clean_db):
        reg = _register(client).json()
        r = client.post(
            "/conversations/conv_001/messages", json={"text": "hi"}, headers=_auth(reg)
        )
        assert r.status_code == 403


class TestNotificationTriggers:
    def test_follow_notifies_followee(self, client, clean_db):
        r = client.post("/sellers/user_004/follow")
        assert r.status_code == 200
        db = SessionLocal()
        try:
            notifs = db.scalars(
                select(Notification).where(Notification.user_id == "user_004")
            ).all()
            assert any(n.type == "follow" for n in notifs)
        finally:
            db.close()

    def test_duplicate_follow_does_not_notify_again(self, client, clean_db):
        client.post("/sellers/user_004/follow")
        client.post("/sellers/user_004/follow")
        db = SessionLocal()
        try:
            notifs = db.scalars(
                select(Notification).where(Notification.user_id == "user_004")
            ).all()
            assert len(notifs) == 1
        finally:
            db.close()

    def test_favorite_notifies_seller(self, client, clean_db):
        client.post("/listings/list_002/favorite")
        db = SessionLocal()
        try:
            notifs = db.scalars(
                select(Notification).where(Notification.user_id == "user_003")
            ).all()
            assert any(n.type == "favorite" for n in notifs)
        finally:
            db.close()

    def test_listing_creation_notifies_followers(self, client, clean_db):
        client.post(
            "/listings",
            json={"title": "Fresh Item", "price": 10, "category": "other"},
        )
        db = SessionLocal()
        try:
            for follower_id in ["user_002", "user_003", "user_004"]:
                notifs = db.scalars(
                    select(Notification).where(Notification.user_id == follower_id)
                ).all()
                assert any(n.type == "listing" for n in notifs)
        finally:
            db.close()


class TestRoles:
    def test_register_user_role_defaults_to_user(self, client, clean_db):
        reg = _register(client).json()
        assert reg["user"]["role"] == "user"

    def test_listing_creation_promotes_to_seller(self, client, clean_db):
        reg = _register(client).json()
        r = client.post(
            "/listings",
            json={"title": "My Shop Item", "price": 99, "category": "other"},
            headers=_auth(reg),
        )
        assert r.status_code == 201
        me = client.get("/auth/me", headers=_auth(reg)).json()
        assert me["role"] == "seller"


class TestAdmin:
    def _make_admin(self, client):
        reg = _register(client).json()
        db = SessionLocal()
        try:
            user = db.get(User, reg["user"]["id"])
            user.role = "admin"
            db.commit()
        finally:
            db.close()
        return reg

    def test_admin_requires_token(self, client, clean_db):
        assert client.get("/admin/users").status_code == 401

    def test_admin_rejects_regular_user(self, client, clean_db):
        reg = _register(client).json()
        r = client.get("/admin/users", headers=_auth(reg))
        assert r.status_code == 403

    def test_admin_lists_users(self, client, clean_db):
        reg = self._make_admin(client)
        r = client.get("/admin/users", headers=_auth(reg))
        assert r.status_code == 200
        data = r.json()
        assert data["totalItems"] >= 1
        assert any(u["email"] == "carlos@example.com" for u in data["items"])

    def test_admin_updates_role(self, client, clean_db):
        reg = self._make_admin(client)
        r = client.patch(
            "/admin/users/user_005/role", json={"role": "seller"}, headers=_auth(reg)
        )
        assert r.status_code == 200
        assert r.json()["role"] == "seller"

    def test_admin_rejects_invalid_role(self, client, clean_db):
        reg = self._make_admin(client)
        r = client.patch(
            "/admin/users/user_005/role", json={"role": "superuser"}, headers=_auth(reg)
        )
        assert r.status_code == 422

    def test_admin_suspends_and_user_loses_access(self, client, clean_db):
        admin = self._make_admin(client)
        victim = _register(client, email="victim@example.com").json()
        r = client.post(
            f"/admin/users/{victim['user']['id']}/suspend", headers=_auth(admin)
        )
        assert r.status_code == 200
        assert r.json()["status"] == "suspended"
        assert client.get("/auth/me", headers=_auth(victim)).status_code == 403

    def test_admin_activates_user(self, client, clean_db):
        admin = self._make_admin(client)
        victim = _register(client, email="victim@example.com").json()
        client.post(
            f"/admin/users/{victim['user']['id']}/suspend", headers=_auth(admin)
        )
        r = client.post(
            f"/admin/users/{victim['user']['id']}/activate", headers=_auth(admin)
        )
        assert r.status_code == 200
        assert r.json()["status"] == "active"

    def test_admin_stats(self, client, clean_db):
        reg = self._make_admin(client)
        r = client.get("/admin/stats", headers=_auth(reg))
        assert r.status_code == 200
        data = r.json()
        assert data["users"] >= 1
        assert data["sellers"] >= 1
        assert data["listings"] >= 1
        assert data["revenue"] >= 0
