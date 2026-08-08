import pytest
from sqlalchemy import select

from flow_app.core.database import SessionLocal
from flow_app.models import PasswordResetToken, RefreshToken, User


def _register(client, **overrides):
    payload = {
        "name": "Test User",
        "email": "test@example.com",
        "password": "StrongPass1",
        **overrides,
    }
    return client.post("/auth/register", json=payload)


def _token_for(db, user_id):
    return db.scalars(select(RefreshToken).where(RefreshToken.user_id == user_id)).all()


class TestRegister:
    def test_register_returns_tokens_and_user(self, client, clean_db):
        r = _register(client)
        assert r.status_code == 201
        data = r.json()
        assert data["tokenType"] == "bearer"
        assert data["accessToken"]
        assert data["refreshToken"]
        assert data["expiresIn"] > 0
        assert data["isVerificationRequired"] is True
        user = data["user"]
        assert user["email"] == "test@example.com"
        assert user["name"] == "Test User"
        assert user["username"] == "test"
        assert user["id"].startswith("user_")

    def test_register_uses_username_when_provided(self, client, clean_db):
        r = _register(client, username="CoolSeller")
        assert r.status_code == 201
        assert r.json()["user"]["username"] == "coolseller"

    def test_register_duplicate_email_rejected(self, client, clean_db):
        assert _register(client).status_code == 201
        r = _register(client, name="Other User")
        assert r.status_code == 409
        assert r.json()["detail"] == "Email already registered"

    def test_register_duplicate_username_rejected(self, client, clean_db):
        assert _register(client).status_code == 201
        r = _register(client, email="other@example.com", username="test")
        assert r.status_code == 409
        assert r.json()["detail"] == "Username already taken"

    def test_register_auto_suffixes_taken_username(self, client, clean_db):
        assert _register(client).status_code == 201
        r = _register(client, email="test@example.net")
        assert r.status_code == 201
        assert r.json()["user"]["username"] == "test_1"

    def test_register_invalid_email_rejected(self, client, clean_db):
        r = _register(client, email="not-an-email")
        assert r.status_code == 422

    def test_register_invalid_username_rejected(self, client, clean_db):
        r = _register(client, username="ab")
        assert r.status_code == 422

    def test_register_weak_password_rejected(self, client, clean_db):
        r = _register(client, password="short")
        assert r.status_code == 422
        r = _register(client, password="onlyletters")
        assert r.status_code == 422
        r = _register(client, password="12345678")
        assert r.status_code == 422

    def test_password_is_hashed(self, client, clean_db):
        r = _register(client)
        user_id = r.json()["user"]["id"]
        db = SessionLocal()
        try:
            user = db.get(User, user_id)
            assert user.password_hash
            assert user.password_hash != "StrongPass1"
            assert user.password_hash.startswith("$2b$")
        finally:
            db.close()


class TestLogin:
    def test_login_with_email(self, client, clean_db):
        _register(client)
        r = client.post(
            "/auth/login", json={"email": "test@example.com", "password": "StrongPass1"}
        )
        assert r.status_code == 200
        data = r.json()
        assert data["accessToken"]
        assert data["refreshToken"]
        assert data["user"]["email"] == "test@example.com"
        assert data["isVerificationRequired"] is True

    def test_login_with_username(self, client, clean_db):
        _register(client)
        r = client.post(
            "/auth/login", json={"username": "test", "password": "StrongPass1"}
        )
        assert r.status_code == 200

    def test_login_updates_last_login(self, client, clean_db):
        _register(client)
        client.post(
            "/auth/login", json={"email": "test@example.com", "password": "StrongPass1"}
        )
        db = SessionLocal()
        try:
            user = db.scalar(select(User).where(User.email == "test@example.com"))
            assert user.last_login_at is not None
        finally:
            db.close()

    def test_login_wrong_password(self, client, clean_db):
        _register(client)
        r = client.post(
            "/auth/login", json={"email": "test@example.com", "password": "WrongPass1"}
        )
        assert r.status_code == 401
        assert r.json()["detail"] == "Invalid email/username or password"

    def test_login_unknown_user_same_error(self, client, clean_db):
        r = client.post(
            "/auth/login", json={"email": "nobody@example.com", "password": "WrongPass1"}
        )
        assert r.status_code == 401
        assert r.json()["detail"] == "Invalid email/username or password"

    def test_login_requires_identifier(self, client, clean_db):
        r = client.post("/auth/login", json={"password": "StrongPass1"})
        assert r.status_code == 422


class TestRefresh:
    def test_refresh_rotates_tokens(self, client, clean_db):
        reg = _register(client).json()
        r = client.post("/auth/refresh", json={"refreshToken": reg["refreshToken"]})
        assert r.status_code == 200
        data = r.json()
        assert data["accessToken"]
        assert data["refreshToken"] != reg["refreshToken"]

    def test_refresh_revokes_old_token(self, client, clean_db):
        reg = _register(client).json()
        refreshed = client.post(
            "/auth/refresh", json={"refreshToken": reg["refreshToken"]}
        ).json()
        r = client.post("/auth/refresh", json={"refreshToken": reg["refreshToken"]})
        assert r.status_code == 401
        assert client.post(
            "/auth/refresh", json={"refreshToken": refreshed["refreshToken"]}
        ).status_code == 200

    def test_refresh_invalid_token(self, client, clean_db):
        r = client.post("/auth/refresh", json={"refreshToken": "bogus-token"})
        assert r.status_code == 401


class TestLogout:
    def test_logout_revokes_refresh_token(self, client, clean_db):
        reg = _register(client).json()
        r = client.post("/auth/logout", json={"refreshToken": reg["refreshToken"]})
        assert r.status_code == 200
        assert client.post(
            "/auth/refresh", json={"refreshToken": reg["refreshToken"]}
        ).status_code == 401

    def test_logout_without_body(self, client, clean_db):
        assert client.post("/auth/logout").status_code == 200


class TestMe:
    def test_me_with_access_token(self, client, clean_db):
        reg = _register(client).json()
        r = client.get(
            "/auth/me", headers={"Authorization": f"Bearer {reg['accessToken']}"}
        )
        assert r.status_code == 200
        assert r.json()["id"] == reg["user"]["id"]
        assert r.json()["email"] == "test@example.com"

    def test_me_without_token_uses_current_user(self, client, clean_db):
        r = client.get("/auth/me")
        assert r.status_code == 200
        assert r.json()["id"] == "user_001"

    def test_me_with_invalid_token(self, client, clean_db):
        r = client.get(
            "/auth/me", headers={"Authorization": "Bearer not-a-real-token"}
        )
        assert r.status_code == 401

    def test_me_with_tampered_token(self, client, clean_db):
        reg = _register(client).json()
        r = client.get(
            "/auth/me",
            headers={"Authorization": f"Bearer {reg['accessToken']}x"},
        )
        assert r.status_code == 401


class TestChangePassword:
    def test_change_password(self, client, clean_db):
        reg = _register(client).json()
        headers = {"Authorization": f"Bearer {reg['accessToken']}"}
        r = client.put(
            "/auth/change-password",
            json={"currentPassword": "StrongPass1", "newPassword": "NewPass99"},
            headers=headers,
        )
        assert r.status_code == 200
        assert client.post(
            "/auth/login", json={"email": "test@example.com", "password": "StrongPass1"}
        ).status_code == 401
        assert client.post(
            "/auth/login", json={"email": "test@example.com", "password": "NewPass99"}
        ).status_code == 200

    def test_change_password_revokes_refresh_tokens(self, client, clean_db):
        reg = _register(client).json()
        headers = {"Authorization": f"Bearer {reg['accessToken']}"}
        client.put(
            "/auth/change-password",
            json={"currentPassword": "StrongPass1", "newPassword": "NewPass99"},
            headers=headers,
        )
        assert client.post(
            "/auth/refresh", json={"refreshToken": reg["refreshToken"]}
        ).status_code == 401

    def test_change_password_wrong_current(self, client, clean_db):
        reg = _register(client).json()
        headers = {"Authorization": f"Bearer {reg['accessToken']}"}
        r = client.put(
            "/auth/change-password",
            json={"currentPassword": "WrongPass1", "newPassword": "NewPass99"},
            headers=headers,
        )
        assert r.status_code == 400
        assert r.json()["detail"] == "Current password is incorrect"

    def test_change_password_weak_new(self, client, clean_db):
        reg = _register(client).json()
        headers = {"Authorization": f"Bearer {reg['accessToken']}"}
        r = client.put(
            "/auth/change-password",
            json={"currentPassword": "StrongPass1", "newPassword": "weak"},
            headers=headers,
        )
        assert r.status_code == 422


class TestForgotResetPassword:
    def test_forgot_password_never_exposes_email(self, client, clean_db):
        known = client.post("/auth/forgot-password", json={"email": "test@example.com"})
        unknown = client.post("/auth/forgot-password", json={"email": "ghost@example.com"})
        assert known.status_code == 200
        assert unknown.status_code == 200
        assert known.json() == unknown.json()

    def test_reset_password_flow(self, client, clean_db, monkeypatch):
        monkeypatch.setattr(
            "flow_app.api.routers.auth.generate_reset_token",
            lambda: "reset-token-abc123",
        )
        _register(client)
        client.post("/auth/forgot-password", json={"email": "test@example.com"})

        r = client.post(
            "/auth/reset-password",
            json={"token": "reset-token-abc123", "newPassword": "FreshPass1"},
        )
        assert r.status_code == 200
        assert client.post(
            "/auth/login", json={"email": "test@example.com", "password": "StrongPass1"}
        ).status_code == 401
        assert client.post(
            "/auth/login", json={"email": "test@example.com", "password": "FreshPass1"}
        ).status_code == 200

    def test_reset_password_token_is_single_use(self, client, clean_db, monkeypatch):
        monkeypatch.setattr(
            "flow_app.api.routers.auth.generate_reset_token",
            lambda: "reset-token-abc123",
        )
        _register(client)
        client.post("/auth/forgot-password", json={"email": "test@example.com"})
        payload = {"token": "reset-token-abc123", "newPassword": "FreshPass1"}
        assert client.post("/auth/reset-password", json=payload).status_code == 200
        assert client.post("/auth/reset-password", json=payload).status_code == 400

    def test_reset_password_invalid_token(self, client, clean_db):
        r = client.post(
            "/auth/reset-password", json={"token": "bogus", "newPassword": "FreshPass1"}
        )
        assert r.status_code == 400

    def test_reset_password_revokes_refresh_tokens(self, client, clean_db, monkeypatch):
        monkeypatch.setattr(
            "flow_app.api.routers.auth.generate_reset_token",
            lambda: "reset-token-abc123",
        )
        reg = _register(client).json()
        client.post("/auth/forgot-password", json={"email": "test@example.com"})
        client.post(
            "/auth/reset-password",
            json={"token": "reset-token-abc123", "newPassword": "FreshPass1"},
        )
        assert client.post(
            "/auth/refresh", json={"refreshToken": reg["refreshToken"]}
        ).status_code == 401

    def test_reset_password_email_only_legacy_alias(self, client, clean_db, monkeypatch):
        monkeypatch.setattr(
            "flow_app.api.routers.auth.generate_reset_token",
            lambda: "legacy-token",
        )
        _register(client)
        r = client.post("/auth/reset-password", json={"email": "test@example.com"})
        assert r.status_code == 200
        db = SessionLocal()
        try:
            reset = db.scalars(select(PasswordResetToken)).all()
            assert any(t.token_hash for t in reset)
        finally:
            db.close()


class TestOtp:
    def test_otp_flow(self, client, clean_db, monkeypatch):
        monkeypatch.setattr("flow_app.api.routers.auth.generate_otp", lambda: "123456")
        r = client.post("/auth/otp/send", json={"phone": "+52 555 0102"})
        assert r.status_code == 200
        assert r.json()["expiresIn"] > 0
        assert client.post(
            "/auth/otp/verify", json={"phone": "+52 555 0102", "otp": "123456"}
        ).status_code == 200

    def test_otp_wrong_code_rejected(self, client, clean_db, monkeypatch):
        monkeypatch.setattr("flow_app.api.routers.auth.generate_otp", lambda: "123456")
        client.post("/auth/otp/send", json={"phone": "+52 555 0102"})
        r = client.post(
            "/auth/otp/verify", json={"phone": "+52 555 0102", "otp": "999999"}
        )
        assert r.status_code == 400

    def test_otp_single_use(self, client, clean_db, monkeypatch):
        monkeypatch.setattr("flow_app.api.routers.auth.generate_otp", lambda: "123456")
        client.post("/auth/otp/send", json={"phone": "+52 555 0102"})
        assert client.post(
            "/auth/otp/verify", json={"phone": "+52 555 0102", "otp": "123456"}
        ).status_code == 200
        assert client.post(
            "/auth/otp/verify", json={"phone": "+52 555 0102", "otp": "123456"}
        ).status_code == 400

    def test_otp_attempt_limit(self, client, clean_db, monkeypatch):
        monkeypatch.setattr("flow_app.api.routers.auth.generate_otp", lambda: "123456")
        client.post("/auth/otp/send", json={"phone": "+52 555 0102"})
        for _ in range(5):
            client.post(
                "/auth/otp/verify", json={"phone": "+52 555 0102", "otp": "000000"}
            )
        r = client.post(
            "/auth/otp/verify", json={"phone": "+52 555 0102", "otp": "123456"}
        )
        assert r.status_code == 400
        assert r.json()["detail"] == "Too many attempts"

    def test_otp_requires_phone(self, client, clean_db):
        assert client.post("/auth/otp/send", json={"phone": ""}).status_code == 400


def _google_claims(email="google.user@example.com", name="Google User", picture=""):
    return {"email": email, "name": name, "picture": picture, "email_verified": True}


class TestGoogleAuth:
    def _sign_in(self, client, monkeypatch, claims=None):
        monkeypatch.setattr(
            "flow_app.api.routers.auth.verify_google_id_token",
            lambda token: _google_claims(**(claims or {})),
        )
        return client.post("/auth/google", json={"idToken": "fake-google-token"})

    def test_google_creates_user_on_first_login(self, client, clean_db, monkeypatch):
        r = self._sign_in(client, monkeypatch, claims={"email": "new@gmail.com"})
        assert r.status_code == 200
        data = r.json()
        assert data["accessToken"]
        assert data["refreshToken"]
        assert data["user"]["email"] == "new@gmail.com"
        assert data["user"]["username"] == "new"
        assert data["user"]["isVerified"] is True
        db = SessionLocal()
        try:
            user = db.get(User, data["user"]["id"])
            assert user.auth_provider == "google"
            assert user.status == "active"
            assert user.password_hash == ""
        finally:
            db.close()

    def test_google_duplicate_email_returns_same_user(self, client, clean_db, monkeypatch):
        first = self._sign_in(client, monkeypatch).json()
        second = self._sign_in(client, monkeypatch).json()
        assert first["user"]["id"] == second["user"]["id"]
        db = SessionLocal()
        try:
            users = db.scalars(select(User).where(User.email == "google.user@example.com")).all()
            assert len(users) == 1
        finally:
            db.close()

    def test_google_links_existing_email_account(self, client, clean_db, monkeypatch):
        _register(client, email="google.user@example.com")
        r = self._sign_in(client, monkeypatch)
        assert r.status_code == 200
        assert r.json()["user"]["isVerified"] is True
        db = SessionLocal()
        try:
            users = db.scalars(select(User).where(User.email == "google.user@example.com")).all()
            assert len(users) == 1
            assert users[0].auth_provider == "google"
        finally:
            db.close()

    def test_google_missing_email_rejected(self, client, clean_db, monkeypatch):
        r = self._sign_in(client, monkeypatch, claims={"email": ""})
        assert r.status_code == 400

    def test_google_invalid_token_rejected(self, client, clean_db, monkeypatch):
        def _boom(_token):
            raise ValueError("Invalid Google ID token")

        monkeypatch.setattr("flow_app.api.routers.auth.verify_google_id_token", _boom)
        r = client.post("/auth/google", json={"idToken": "bad-token"})
        assert r.status_code == 401


class TestEmailVerify:
    def test_send_and_confirm_code(self, client, clean_db, monkeypatch):
        monkeypatch.setattr("flow_app.api.routers.auth.generate_otp", lambda: "654321")
        monkeypatch.setattr("flow_app.api.routers.auth.send_email", lambda *a, **k: None)
        reg = _register(client).json()
        headers = {"Authorization": f"Bearer {reg['accessToken']}"}

        r = client.post("/auth/email-verify/send", headers=headers)
        assert r.status_code == 200
        assert r.json()["alreadyVerified"] is False
        assert r.json()["expiresIn"] > 0

        r = client.post(
            "/auth/email-verify/confirm", json={"code": "654321"}, headers=headers
        )
        assert r.status_code == 200
        assert r.json()["user"]["isVerified"] is True

        r = client.post("/auth/email-verify/send", headers=headers)
        assert r.status_code == 200
        assert r.json()["alreadyVerified"] is True

    def test_confirm_wrong_code_rejected(self, client, clean_db, monkeypatch):
        monkeypatch.setattr("flow_app.api.routers.auth.generate_otp", lambda: "654321")
        monkeypatch.setattr("flow_app.api.routers.auth.send_email", lambda *a, **k: None)
        reg = _register(client).json()
        headers = {"Authorization": f"Bearer {reg['accessToken']}"}
        client.post("/auth/email-verify/send", headers=headers)
        r = client.post(
            "/auth/email-verify/confirm", json={"code": "000000"}, headers=headers
        )
        assert r.status_code == 400
        assert r.json()["detail"] == "Invalid verification code"

    def test_confirm_without_code_issuing_rejected(self, client, clean_db):
        reg = _register(client).json()
        headers = {"Authorization": f"Bearer {reg['accessToken']}"}
        r = client.post(
            "/auth/email-verify/confirm", json={"code": "654321"}, headers=headers
        )
        assert r.status_code == 400

    def test_confirm_requires_auth(self, client, clean_db):
        assert client.post(
            "/auth/email-verify/confirm", json={"code": "654321"}
        ).status_code == 401


class TestSuspendedAccount:
    def test_suspended_user_cannot_login(self, client, clean_db):
        reg = _register(client).json()
        db = SessionLocal()
        try:
            user = db.get(User, reg["user"]["id"])
            user.status = "suspended"
            db.commit()
        finally:
            db.close()
        r = client.post(
            "/auth/login",
            json={"email": "test@example.com", "password": "StrongPass1"},
        )
        assert r.status_code == 403
        assert r.json()["detail"] == "Account is suspended"

    def test_suspended_user_token_rejected_on_protected_endpoint(
        self, client, clean_db
    ):
        reg = _register(client).json()
        db = SessionLocal()
        try:
            user = db.get(User, reg["user"]["id"])
            user.status = "suspended"
            db.commit()
        finally:
            db.close()
        headers = {"Authorization": f"Bearer {reg['accessToken']}"}
        assert client.get("/auth/me", headers=headers).status_code == 403
