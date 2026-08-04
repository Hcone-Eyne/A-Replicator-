import time

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import and_, func, or_, select
from sqlalchemy.orm import Session

from ...config import settings
from ...core.database import get_db
from ...core.services import create_notification
from ...models import Conversation, Message, User
from ..schemas import ConversationCreateRequest, MessageSendRequest
from ..serializers import serialize_conversation, serialize_message

router = APIRouter(tags=["messages"])


def _other_user(db: Session, conv: Conversation, user_id: str) -> User:
    other_id = conv.user_b_id if conv.user_a_id == user_id else conv.user_a_id
    other = db.get(User, other_id)
    if not other:
        raise HTTPException(status_code=404, detail="Other user not found")
    return other


def _existing_conversation(db: Session, user_a: str, user_b: str) -> Conversation | None:
    return db.scalar(
        select(Conversation).where(
            or_(
                and_(
                    Conversation.user_a_id == user_a,
                    Conversation.user_b_id == user_b,
                ),
                and_(
                    Conversation.user_a_id == user_b,
                    Conversation.user_b_id == user_a,
                ),
            )
        )
    )


@router.post("/conversations", status_code=201)
def create_conversation(
    body: ConversationCreateRequest,
    db: Session = Depends(get_db),
):
    user_id = settings.current_user_id
    if user_id == body.otherUserId:
        raise HTTPException(status_code=400, detail="Cannot chat with yourself")
    other = db.get(User, body.otherUserId)
    if not other:
        raise HTTPException(status_code=404, detail="User not found")

    conv = _existing_conversation(db, user_id, body.otherUserId)
    if not conv:
        conv = Conversation(
            id=f"conv_{int(time.time() * 1000)}",
            user_a_id=user_id,
            user_b_id=body.otherUserId,
            last_message=body.initialMessage,
            last_message_time=func.now(),
            unread_count=0,
            is_online=False,
            product_title=body.productTitle,
            product_image=body.productImage,
        )
        db.add(conv)
        db.flush()

    if body.initialMessage:
        message = Message(
            id=f"msg_{int(time.time() * 1000)}",
            conversation_id=conv.id,
            sender_id=user_id,
            text=body.initialMessage,
            image_url="",
        )
        db.add(message)
        conv.last_message = body.initialMessage
        conv.last_message_time = func.now()
        create_notification(
            db,
            user_id=body.otherUserId,
            title="New Message",
            body=f"{other.name} sent you a message.",
            type="message",
            data={"conversationId": conv.id},
        )

    db.commit()
    db.refresh(conv)
    return serialize_conversation(conv, other)


@router.get("/conversations")
def get_conversations(db: Session = Depends(get_db)):
    user_id = settings.current_user_id
    rows = db.scalars(
        select(Conversation)
        .where(or_(Conversation.user_a_id == user_id, Conversation.user_b_id == user_id))
        .order_by(Conversation.last_message_time.desc())
    ).all()
    return [serialize_conversation(c, _other_user(db, c, user_id)) for c in rows]


@router.get("/conversations/{conv_id}/messages")
def get_messages(
    conv_id: str,
    limit: int = Query(50, ge=1, le=200),
    before: str | None = None,
    db: Session = Depends(get_db),
):
    conv = db.get(Conversation, conv_id)
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")

    query = select(Message).where(Message.conversation_id == conv_id)
    if before:
        query = query.where(Message.timestamp < before)
    query = query.order_by(Message.timestamp.desc()).limit(limit)
    rows = list(reversed(db.scalars(query).all()))
    return [serialize_message(m) for m in rows]


@router.post("/conversations/{conv_id}/messages", status_code=201)
def send_message(conv_id: str, body: MessageSendRequest, db: Session = Depends(get_db)):
    conv = db.get(Conversation, conv_id)
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")

    sender_id = settings.current_user_id
    message = Message(
        id=f"msg_{int(time.time() * 1000)}",
        conversation_id=conv_id,
        sender_id=sender_id,
        text=body.text,
        image_url=body.imageUrl,
    )
    db.add(message)
    conv.last_message = body.text
    conv.last_message_time = func.now()

    other_id = conv.user_b_id if conv.user_a_id == sender_id else conv.user_a_id
    if other_id != sender_id:
        conv.unread_count += 1
        other = db.get(User, other_id)
        create_notification(
            db,
            user_id=other_id,
            title="New Message",
            body=f"{other.name} sent you a message." if other else "You have a new message.",
            type="message",
            data={"conversationId": conv.id},
        )
    db.commit()
    db.refresh(message)
    return serialize_message(message)


@router.post("/conversations/{conv_id}/read")
def mark_conversation_read(conv_id: str, db: Session = Depends(get_db)):
    conv = db.get(Conversation, conv_id)
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")

    user_id = settings.current_user_id
    for message in db.scalars(
        select(Message).where(
            Message.conversation_id == conv_id,
            Message.sender_id != user_id,
            Message.is_read.is_(False),
        )
    ).all():
        message.is_read = True
    conv.unread_count = 0
    db.commit()
    return {"ok": True}


@router.get("/conversations/unread-count")
def get_conversations_unread_count(db: Session = Depends(get_db)):
    user_id = settings.current_user_id
    total = db.scalar(
        select(func.coalesce(func.sum(Conversation.unread_count), 0)).where(
            or_(Conversation.user_a_id == user_id, Conversation.user_b_id == user_id)
        )
    )
    return {"count": int(total)}
