import logging
import re
import secrets
import time
from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select, update
from sqlalchemy.orm import Session

from ...config import settings
from ...core.database import get_db
from ...core.google_auth import verify_google_id_token
from ...core.mailer import send_email
from ...core.security import (
    create_access_token,
    create_refresh_session,
    generate_otp,
    generate_refresh_token,
    generate_reset_token,
    get_authenticated_user,
    get_current_user,
    hash_password,
    hash_token,
    revoke_all_user_refresh_tokens,
    revoke_refresh_token,
    utcnow,
    validate_refresh_token,
    verify_otp,
    verify_password,
)
from ...core.services import user_payload
from ...models import OtpCode, PasswordResetToken, RefreshToken, User
from ..schemas import (
    ChangePasswordRequest,
    EmailVerifyConfirmRequest,
    EmailVerifySendRequest,
    ForgotPasswordRequest,
    GoogleAuthRequest,
    LoginRequest,
    LogoutRequest,
    OtpSendRequest,
    OtpVerifyRequest,
    RefreshRequest,
    RegisterRequest,
    ResetPasswordRequest,
)

router = APIRouter(prefix="/auth", tags=["auth"])

logger = logging.getLogger("flow_app.auth")


def _new_id(prefix: str) -> str:
    return f"{prefix}_{int(time.time() * 1000)}_{secrets.token_hex(3)}"


def _suggest_username(email: str) -> str:
    base = email.split("@", 1)[0].lower()
    base = re.sub(r"[^a-z0-9_.-]", "", base)[:30]
    return base or "user"


def _unique_username(db: Session, base: str) -> str:
    candidate = base
    suffix = 1
    while db.scalar(select(User.id).where(User.username == candidate)):
        candidate = f"{base}_{suffix}"
        suffix += 1
    return candidate


def _token_payload(db: Session, user: User, refresh_token: str) -> dict:
    access_token, expires_in = create_access_token(user.id)
    return {
        "accessToken": access_token,
        "refreshToken": refresh_token,
        "tokenType": "bearer",
        "expiresIn": expires_in,
        "isVerificationRequired": not user.is_verified,
        "user": user_payload(db, user, user.id),
    }


def _issue_password_reset(db: Session, user: User) -> None:
    token = generate_reset_token()
    db.add(
        PasswordResetToken(
            id=_new_id("reset"),
            user_id=user.id,
            token_hash=hash_token(token),
            expires_at=utcnow() + timedelta(minutes=settings.reset_token_expire_minutes),
        )
    )
    send_email(
        user.email,
        "Reset your Flow password",
        text=(
            "You requested a password reset.\n\n"
            f"Use this code in the app to set a new password:\n\n{token}\n\n"
            f"The code expires in {settings.reset_token_expire_minutes} minutes.\n"
            "If you did not request this, you can safely ignore this email."
        ),
    )


def _issue_email_verify(db: Session, user: User) -> str:
    code = generate_otp()
    user.email_verify_code_hash = hash_token(code)
    user.email_verify_expires_at = utcnow() + timedelta(
        minutes=settings.email_verify_expire_minutes
    )
    user.updated_at = utcnow()
    send_email(
        user.email,
        "Verify your Flow email",
        text=(
            "Welcome to Flow! Verify your email address with this code:\n\n"
            f"{code}\n\n"
            f"The code expires in {settings.email_verify_expire_minutes} minutes."
        ),
    )
    return code


def _issue_session(db: Session, user: User) -> dict:
    """Create a refresh session and return the token payload."""
    user.last_login_at = utcnow()
    user.updated_at = utcnow()
    refresh_token = generate_refresh_token()
    db.flush()
    create_refresh_session(db, user.id, refresh_token)
    db.commit()
    db.refresh(user)
    return _token_payload(db, user, refresh_token)


def _ensure_active(user: User) -> None:
    if user.status == "suspended":
        raise HTTPException(status_code=403, detail="Account is suspended")


@router.post("/register", status_code=201)
def register(body: RegisterRequest, db: Session = Depends(get_db)):
    email = body.email.lower()
    if db.scalar(select(User.id).where(User.email == email)):
        raise HTTPException(status_code=409, detail="Email already registered")

    if body.username:
        if db.scalar(select(User.id).where(User.username == body.username)):
            raise HTTPException(status_code=409, detail="Username already taken")
        username = body.username
    else:
        username = _unique_username(db, _suggest_username(email))

    user = User(
        id=_new_id("user"),
        username=username,
        name=body.name,
        email=email,
        auth_provider="email",
        phone=body.phone,
        password_hash=hash_password(body.password),
    )
    db.add(user)
    db.flush()
    _issue_email_verify(db, user)
    return _issue_session(db, user)


@router.post("/login")
def login(body: LoginRequest, db: Session = Depends(get_db)):
    if body.email:
        query = select(User).where(User.email == body.email.lower())
    else:
        query = select(User).where(User.username == body.username)
    user = db.scalar(query)
    if user is None or not verify_password(body.password, user.password_hash):
        raise HTTPException(
            status_code=401, detail="Invalid email/username or password"
        )

    _ensure_active(user)
    return _issue_session(db, user)


@router.post("/google")
def google_auth(body: GoogleAuthRequest, db: Session = Depends(get_db)):
    """Sign in with a Google ID token, creating the account on first use."""
    try:
        claims = verify_google_id_token(body.idToken)
    except ValueError as exc:
        raise HTTPException(status_code=401, detail=str(exc)) from exc
    except RuntimeError as exc:
        raise HTTPException(status_code=503, detail=str(exc)) from exc

    email = (claims.get("email") or "").lower()
    if not email:
        raise HTTPException(status_code=400, detail="Google account has no email")

    user = db.scalar(select(User).where(User.email == email))
    if user is None:
        user = User(
            id=_new_id("user"),
            username=_unique_username(db, _suggest_username(email)),
            name=claims.get("name") or email.split("@", 1)[0],
            email=email,
            auth_provider="google",
            avatar_url=claims.get("picture") or "",
            is_verified=True,
        )
        db.add(user)
    else:
        _ensure_active(user)
        user.auth_provider = "google"
        if claims.get("picture"):
            user.avatar_url = claims.get("picture")
        if not user.is_verified:
            user.is_verified = True

    return _issue_session(db, user)


@router.post("/logout")
def logout(body: LogoutRequest | None = None, db: Session = Depends(get_db)):
    if body and body.refreshToken:
        revoke_refresh_token(db, body.refreshToken)
    return {"ok": True}


@router.post("/refresh")
def refresh(body: RefreshRequest, db: Session = Depends(get_db)):
    session = validate_refresh_token(db, body.refreshToken)
    if session is None:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token")

    revoked = db.execute(
        update(RefreshToken)
        .where(RefreshToken.id == session.id, RefreshToken.revoked_at.is_(None))
        .values(revoked_at=utcnow())
    )
    if revoked.rowcount == 0:
        db.rollback()
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token")

    user = db.get(User, session.user_id)
    if user is None:
        db.rollback()
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token")
    if user.status == "suspended":
        db.rollback()
        raise HTTPException(status_code=403, detail="Account is suspended")

    refresh_token = generate_refresh_token()
    create_refresh_session(db, user.id, refresh_token, replaced_by=session.id)
    db.commit()
    return _token_payload(db, user, refresh_token)


@router.get("/me")
def me(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return user_payload(db, current_user, current_user.id)


@router.post("/email-verify/send")
def send_email_verify(
    body: EmailVerifySendRequest | None = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_authenticated_user),
):
    if current_user.is_verified:
        return {"ok": True, "alreadyVerified": True}

    _issue_email_verify(db, current_user)
    db.commit()
    return {
        "ok": True,
        "alreadyVerified": False,
        "expiresIn": settings.email_verify_expire_minutes * 60,
    }


@router.post("/email-verify/confirm")
def confirm_email_verify(
    body: EmailVerifyConfirmRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_authenticated_user),
):
    if current_user.is_verified:
        return {"ok": True, "alreadyVerified": True}

    expires_at = current_user.email_verify_expires_at
    if not current_user.email_verify_code_hash or expires_at is None or expires_at < utcnow():
        raise HTTPException(status_code=400, detail="Verification code expired")

    if not verify_otp(body.code, current_user.email_verify_code_hash):
        raise HTTPException(status_code=400, detail="Invalid verification code")

    current_user.is_verified = True
    current_user.email_verify_code_hash = ""
    current_user.email_verify_expires_at = None
    current_user.updated_at = utcnow()
    db.commit()
    return {"ok": True, "user": user_payload(db, current_user, current_user.id)}


@router.put("/change-password")
def change_password(
    body: ChangePasswordRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if not verify_password(body.currentPassword, current_user.password_hash):
        raise HTTPException(status_code=400, detail="Current password is incorrect")

    current_user.password_hash = hash_password(body.newPassword)
    current_user.updated_at = utcnow()
    revoke_all_user_refresh_tokens(db, current_user.id)
    db.commit()
    return {"ok": True}


@router.post("/forgot-password")
def forgot_password(body: ForgotPasswordRequest, db: Session = Depends(get_db)):
    user = db.scalar(select(User).where(User.email == body.email.lower()))
    if user:
        _issue_password_reset(db, user)
        db.commit()
    return {
        "ok": True,
        "message": "If that email is registered, a password reset link has been sent.",
    }


@router.post("/reset-password")
def reset_password(body: ResetPasswordRequest, db: Session = Depends(get_db)):
    if body.email and not body.token:
        user = db.scalar(select(User).where(User.email == body.email.lower()))
        if user:
            _issue_password_reset(db, user)
            db.commit()
        return {"ok": True}

    reset = db.scalar(
        select(PasswordResetToken).where(PasswordResetToken.token_hash == hash_token(body.token))
    )
    if reset is None or reset.used_at is not None or reset.expires_at < utcnow():
        raise HTTPException(status_code=400, detail="Invalid or expired reset token")

    user = db.get(User, reset.user_id)
    if user is None:
        raise HTTPException(status_code=400, detail="Invalid or expired reset token")

    user.password_hash = hash_password(body.newPassword)
    reset.used_at = utcnow()
    revoke_all_user_refresh_tokens(db, user.id)
    db.commit()
    return {"ok": True}


@router.post("/otp/send")
def send_otp(body: OtpSendRequest, db: Session = Depends(get_db)):
    if not body.phone:
        raise HTTPException(status_code=400, detail="Phone number is required")

    code = generate_otp()
    logger.info("[dev-otp] Phone %s: code %s", body.phone, code)
    db.add(
        OtpCode(
            id=_new_id("otp"),
            phone=body.phone,
            code_hash=hash_token(code),
            expires_at=utcnow() + timedelta(minutes=settings.otp_expire_minutes),
        )
    )
    db.commit()
    return {"ok": True, "expiresIn": settings.otp_expire_minutes * 60}


@router.post("/otp/verify")
def verify_otp_endpoint(body: OtpVerifyRequest, db: Session = Depends(get_db)):
    if not body.phone or not body.otp:
        raise HTTPException(status_code=400, detail="Phone and OTP code are required")

    otp = db.scalars(
        select(OtpCode)
        .where(OtpCode.phone == body.phone)
        .order_by(OtpCode.created_at.desc())
    ).first()
    if otp is None or otp.expires_at < utcnow():
        raise HTTPException(status_code=400, detail="Invalid or expired OTP code")
    if otp.attempts >= 5:
        db.delete(otp)
        db.commit()
        raise HTTPException(status_code=400, detail="Too many attempts")

    if not verify_otp(body.otp, otp.code_hash):
        otp.attempts += 1
        db.commit()
        raise HTTPException(status_code=400, detail="Invalid or expired OTP code")

    db.delete(otp)
    db.commit()
    return {"ok": True}
