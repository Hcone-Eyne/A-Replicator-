"""File upload endpoint.

Saves uploaded images to the configured upload directory and returns a
public URL served by the /uploads static mount (see main.py).
"""
import uuid
from pathlib import Path

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile

from ...config import settings
from ...core.security import get_current_user
from ...models import User

router = APIRouter(tags=["uploads"])

ALLOWED_EXTENSIONS = {".png", ".jpg", ".jpeg", ".gif", ".webp"}
MAX_SIZE_BYTES = 10 * 1024 * 1024
_CHUNK_SIZE = 1024 * 1024


@router.post("/upload", status_code=201)
async def upload_file(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
):
    ext = Path(file.filename or "").suffix.lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=400,
            detail="Unsupported file type. Allowed: png, jpg, jpeg, gif, webp",
        )

    total = 0
    chunks = []
    while True:
        chunk = await file.read(_CHUNK_SIZE)
        if not chunk:
            break
        total += len(chunk)
        if total > MAX_SIZE_BYTES:
            raise HTTPException(status_code=400, detail="File too large (max 10MB)")
        chunks.append(chunk)

    upload_dir = Path(settings.upload_dir).resolve()
    upload_dir.mkdir(parents=True, exist_ok=True)

    name = f"{uuid.uuid4().hex}{ext}"
    (upload_dir / name).write_bytes(b"".join(chunks))
    return {"url": f"/uploads/{name}", "name": name}
