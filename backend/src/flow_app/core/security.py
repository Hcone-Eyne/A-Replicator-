"""Password hashing, JWT handling and request authentication dependencies.

The rest of the app still resolves the acting user to ``settings.current_user_id``
(project-wide impersonation for the demo). These helpers enable real credential
auth: any request that carries a valid ``Authorization: Bearer <token>`` header is
resolved to the token's subject; requests without a header keep the impersonation
behaviour so existing clients continue to work.
"""
import hashlib
import hmac
import secrets
from datetime import datetime, timedelta, timezone

import bcrypt
import jwt as pyjwt
from fastapi import Depends, Header, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from ..config import settings
from ..models import RefreshToken, User
from .database import get_db


def utcnow() -> datetime:
    """Naive UTC datetime suitable for storage in MySQL DATETIME columns."""
    return datetime.now(timezone.utc).replace(tzinfo=None)


# --------------------------------------------------------------------------
# Password hashing (bcrypt)
# --------------------------------------------------------------------------

def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")


def verify_password(password: str, password_hash: str) -> bool:
    if not password_hash:
        return False
    try:
        return bcrypt.checkpw(password.encode("utf-8"), password_hash.encode("utf-8"))
    except ValueError:
        return False


# --------------------------------------------------------------------------
# Access tokens (JWT)
# --------------------------------------------------------------------------

def create_access_token(user_id: str) -> tuple[str, int]:
    """Return (encoded JWT, lifetime in seconds)."""
    expires_at = datetime.now(timezone.utc) + timedelta(
        minutes=settings.access_token_expire_minutes
    )
    payload = {
        "sub": user_id,
        "type": "access",
        "iat": datetime.now(timezone.utc),
        "exp": expires_at,
    }
    token = pyjwt.encode(
        payload, settings.jwt_secret_key, algorithm=settings.jwt_algorithm
    )
    return token, settings.access_token_expire_minutes * 60


def decode_access_token(token: str) -> str | None:
    """Return the subject user id for a valid access token, else None."""
    try:
        payload = pyjwt.decode(
            token, settings.jwt_secret_key, algorithms=[settings.jwt_algorithm]
        )
    except pyjwt.PyJWTError:
        return None
    if payload.get("type") != "access":
        return None
    return payload.get("sub")


# --------------------------------------------------------------------------
# Refresh tokens (opaque, stored hashed so they can be revoked)
# --------------------------------------------------------------------------

def generate_refresh_token() -> str:
    return secrets.token_urlsafe(64)


def hash_token(token: str) -> str:
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


def create_refresh_session(
    db: Session, user_id: str, token: str, replaced_by: str | None = None
) -> RefreshToken:
    """Persist a refresh token session. Caller is responsible for commit."""
    import secrets
    import time

    session = RefreshToken(
        id=f"refresh_{int(time.time() * 1000)}_{secrets.token_hex(3)}",
        user_id=user_id,
        token_hash=hash_token(token),
        expires_at=utcnow() + timedelta(days=settings.refresh_token_expire_days),
        replaced_by=replaced_by,
    )
    db.add(session)
    return session


def revoke_refresh_token(db: Session, token: str) -> bool:
    session = db.scalar(
        select(RefreshToken).where(RefreshToken.token_hash == hash_token(token))
    )
    if session and session.revoked_at is None:
        session.revoked_at = utcnow()
        db.commit()
        return True
    return False


def revoke_all_user_refresh_tokens(db: Session, user_id: str) -> int:
    rows = db.scalars(
        select(RefreshToken).where(
            RefreshToken.user_id == user_id,
            RefreshToken.revoked_at.is_(None),
        )
    ).all()
    for row in rows:
        row.revoked_at = utcnow()
    return len(rows)


def validate_refresh_token(db: Session, token: str) -> RefreshToken | None:
    """Return the active, unexpired session for a refresh token, else None."""
    session = db.scalar(
        select(RefreshToken).where(RefreshToken.token_hash == hash_token(token))
    )
    if session is None or session.revoked_at is not None:
        return None
    if session.expires_at < utcnow():
        return None
    return session


# --------------------------------------------------------------------------
# One-time codes (OTP and password reset)
# --------------------------------------------------------------------------

def generate_otp() -> str:
    return f"{secrets.randbelow(1_000_000):06d}"


def generate_reset_token() -> str:
    return secrets.token_urlsafe(48)


def verify_otp(code: str, code_hash: str) -> bool:
    if not code_hash:
        return False
    return hmac.compare_digest(hash_token(code), code_hash)


# --------------------------------------------------------------------------
# Request authentication dependencies
# --------------------------------------------------------------------------

def _user_from_authorization(db: Session, authorization: str | None) -> User | None:
    if not authorization:
        return None
    scheme, _, token = authorization.partition(" ")
    if scheme.lower() != "bearer" or not token:
        return None
    user_id = decode_access_token(token.strip())
    if not user_id:
        return None
    return db.get(User, user_id)


def _active_or_raise(user: User) -> User:
    """Reject accounts that are not in the active status (e.g. suspended)."""
    if user.status != "active":
        raise HTTPException(status_code=403, detail="Account is suspended")
    return user


def get_current_user(
    authorization: str | None = Header(default=None),
    db: Session = Depends(get_db),
) -> User:
    """Resolve the authenticated user.

    A valid Bearer token wins. Without a header the acting user falls back to
    ``settings.current_user_id`` (existing impersonation behaviour). A present but
    invalid token is rejected with 401 so real credentials are always honoured.
    Non-active accounts (e.g. suspended) are rejected with 403.
    """
    user = _user_from_authorization(db, authorization)
    if user is None and authorization is None:
        user = db.get(User, settings.current_user_id)
    if user is None:
        raise HTTPException(
            status_code=401,
            detail="Not authenticated",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return _active_or_raise(user)


def get_authenticated_user(
    authorization: str | None = Header(default=None),
    db: Session = Depends(get_db),
) -> User:
    """Resolve the user from a valid Bearer token.

    Unlike :func:`get_current_user` this never falls back to the impersonated
    ``current_user_id`` — callers must present real credentials. Used by
    account-mutating auth endpoints. Non-active accounts are rejected with 403.
    """
    user = _user_from_authorization(db, authorization)
    if user is None:
        raise HTTPException(
            status_code=401,
            detail="Not authenticated",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return _active_or_raise(user)
