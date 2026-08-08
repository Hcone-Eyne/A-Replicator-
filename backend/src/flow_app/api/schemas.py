import re

from pydantic import BaseModel, EmailStr, Field, field_validator, model_validator

_USERNAME_RE = re.compile(r"^[a-zA-Z0-9_.-]{3,30}$")


def _validate_password_strength(value: str) -> str:
    if not re.search(r"[A-Za-z]", value) or not re.search(r"\d", value):
        raise ValueError("Password must contain at least one letter and one number")
    return value


def _validate_username(value: str) -> str:
    value = value.strip().lower()
    if not _USERNAME_RE.match(value):
        raise ValueError(
            "Username must be 3-30 characters and use only letters, numbers, dots, dashes or underscores"
        )
    return value


class LoginRequest(BaseModel):
    email: EmailStr | None = None
    username: str | None = None
    password: str

    @model_validator(mode="after")
    def require_identifier(self) -> "LoginRequest":
        if not self.email and not self.username:
            raise ValueError("Provide either an email or a username")
        return self

    @field_validator("email")
    @classmethod
    def normalize_email(cls, value: EmailStr | None) -> str | None:
        if value is None:
            return None
        return value.lower()

    @field_validator("username")
    @classmethod
    def normalize_username(cls, value: str | None) -> str | None:
        if value is None:
            return None
        return value.strip().lower()


class RegisterRequest(BaseModel):
    name: str = Field(min_length=2, max_length=255)
    email: EmailStr
    username: str | None = None
    phone: str = ""
    password: str = Field(min_length=8, max_length=72)

    @field_validator("email")
    @classmethod
    def normalize_email(cls, value: EmailStr) -> str:
        return value.lower()

    @field_validator("username")
    @classmethod
    def validate_username(cls, value: str | None) -> str | None:
        if value is None:
            return None
        return _validate_username(value)

    @field_validator("password")
    @classmethod
    def validate_password_strength(cls, value: str) -> str:
        return _validate_password_strength(value)


class OtpSendRequest(BaseModel):
    phone: str


class OtpVerifyRequest(BaseModel):
    phone: str
    otp: str


class LogoutRequest(BaseModel):
    refreshToken: str | None = None


class RefreshRequest(BaseModel):
    refreshToken: str


class GoogleAuthRequest(BaseModel):
    idToken: str = Field(min_length=1)


class EmailVerifySendRequest(BaseModel):
    pass


class EmailVerifyConfirmRequest(BaseModel):
    code: str = Field(min_length=6, max_length=6)


class ChangePasswordRequest(BaseModel):
    currentPassword: str
    newPassword: str = Field(min_length=8, max_length=72)

    @field_validator("newPassword")
    @classmethod
    def validate_password_strength(cls, value: str) -> str:
        return _validate_password_strength(value)


class ForgotPasswordRequest(BaseModel):
    email: EmailStr

    @field_validator("email")
    @classmethod
    def normalize_email(cls, value: EmailStr) -> str:
        return value.lower()


class ResetPasswordRequest(BaseModel):
    token: str | None = None
    newPassword: str | None = Field(default=None, min_length=8, max_length=72)
    email: EmailStr | None = None

    @model_validator(mode="after")
    def require_token_or_email(self) -> "ResetPasswordRequest":
        if not self.token and not self.email:
            raise ValueError("Provide a reset token and a new password")
        if self.token and not self.newPassword:
            raise ValueError("newPassword is required when a token is provided")
        return self

    @field_validator("newPassword")
    @classmethod
    def validate_password_strength(cls, value: str | None) -> str | None:
        if value is None:
            return None
        return _validate_password_strength(value)

    @field_validator("email")
    @classmethod
    def normalize_email(cls, value: EmailStr | None) -> str | None:
        if value is None:
            return None
        return value.lower()


class ListingCreateRequest(BaseModel):
    sellerId: str | None = None
    title: str = ""
    description: str = ""
    price: float = 0.0
    images: list[str] = []
    category: str = ""
    subcategory: str = ""
    condition: str = ""
    location: str = ""


class ListingUpdateRequest(BaseModel):
    title: str | None = None
    description: str | None = None
    price: float | None = None
    images: list[str] | None = None
    category: str | None = None
    subcategory: str | None = None
    condition: str | None = None
    location: str | None = None


class ProfileUpdateRequest(BaseModel):
    name: str | None = None
    phone: str | None = None
    location: str | None = None
    avatarUrl: str | None = None


class MessageSendRequest(BaseModel):
    text: str = ""
    imageUrl: str = ""


class OrderCancelRequest(BaseModel):
    reason: str | None = None


class OrderCreateRequest(BaseModel):
    listingId: str
    quantity: int = Field(default=1, ge=1)
    shippingAddress: str = ""
    paymentMethod: str = ""


class ConversationCreateRequest(BaseModel):
    otherUserId: str
    productId: str | None = None
    productTitle: str = ""
    productImage: str = ""
    initialMessage: str = ""


class ReviewCreateRequest(BaseModel):
    rating: int = 5
    text: str = ""
    hasPhoto: bool = False
    photoUrl: str = ""


class RoleUpdateRequest(BaseModel):
    role: str

    @field_validator("role")
    @classmethod
    def validate_role(cls, value: str) -> str:
        if value not in {"user", "seller", "admin"}:
            raise ValueError("Role must be one of: user, seller, admin")
        return value
