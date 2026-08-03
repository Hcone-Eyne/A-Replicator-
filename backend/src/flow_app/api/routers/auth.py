from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from ...config import settings
from ...core.database import get_db
from ...core.services import user_payload
from ...models import User
from ..schemas import (
    LoginRequest,
    OtpSendRequest,
    OtpVerifyRequest,
    RegisterRequest,
    ResetPasswordRequest,
)

router = APIRouter(prefix="/auth", tags=["auth"])


def _current_user_id(db: Session, user_id: str | None) -> str:
    if user_id and db.get(User, user_id):
        return user_id
    return settings.current_user_id


@router.get("/me")
def me(db: Session = Depends(get_db), user_id: str | None = None):
    uid = _current_user_id(db, user_id)
    user = db.get(User, uid)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user_payload(db, user, uid)


@router.post("/login")
def login(body: LoginRequest, db: Session = Depends(get_db)):
    user = db.scalar(select(User).where(User.email == body.email))
    if not user:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    return user_payload(db, user, user.id)


@router.post("/register")
def register(body: RegisterRequest, db: Session = Depends(get_db)):
    if db.scalar(select(User.id).where(User.email == body.email)):
        raise HTTPException(status_code=409, detail="Email already registered")
    import time

    user = User(
        id=f"user_{int(time.time() * 1000)}",
        name=body.name,
        email=body.email,
        phone=body.phone,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user_payload(db, user, user.id)


@router.post("/logout")
def logout():
    return {"ok": True}


@router.post("/otp/send")
def send_otp(body: OtpSendRequest):
    if not body.phone:
        raise HTTPException(status_code=400, detail="Invalid phone number")
    return {"ok": True}


@router.post("/otp/verify")
def verify_otp(body: OtpVerifyRequest):
    if body.otp != "123456":
        raise HTTPException(status_code=400, detail="Invalid OTP code")
    return {"ok": True}


@router.post("/reset-password")
def reset_password(body: ResetPasswordRequest, db: Session = Depends(get_db)):
    user = db.scalar(select(User).where(User.email == body.email))
    if not user:
        raise HTTPException(status_code=404, detail="Email not found")
    return {"ok": True}
