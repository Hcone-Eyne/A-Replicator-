from pydantic import BaseModel


class LoginRequest(BaseModel):
    email: str
    password: str


class RegisterRequest(BaseModel):
    name: str
    email: str
    phone: str = ""
    password: str


class OtpSendRequest(BaseModel):
    phone: str


class OtpVerifyRequest(BaseModel):
    phone: str
    otp: str


class ResetPasswordRequest(BaseModel):
    email: str


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
    quantity: int = 1
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
