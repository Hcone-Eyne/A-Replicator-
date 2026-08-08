"""Google Sign-In support.

``verify_google_id_token`` validates the ID token a Flutter client receives
from the ``google_sign_in`` plugin. With a configured ``FLOW_GOOGLE_CLIENT_ID``
(comma-separated: Web + iOS + Android client ids) the token signature and
audience are verified against Google's public keys; without one (dev mode) the
claims are trusted as-is so the flow works without real Google credentials.
"""
import logging

import jwt as pyjwt

from ..config import settings

logger = logging.getLogger("flow_app.google_auth")


def verify_google_id_token(token: str) -> dict:
    """Return the verified Google ID token claims (email, name, picture...)."""
    if not token:
        raise ValueError("Google ID token is required")

    client_ids = settings.google_client_ids
    if client_ids:
        from google.auth.transport import requests as google_requests
        from google.oauth2 import id_token as google_id_token

        info = google_id_token.verify_oauth2_token(
            token,
            google_requests.Request(),
            client_ids,
            clock_skew_in_seconds=60,
        )
        return info

    if not settings.google_allow_unverified:
        raise RuntimeError("Google Sign-In is not configured (FLOW_GOOGLE_CLIENT_ID)")

    # Dev mode: decode claims without verifying signature/audience.
    try:
        payload = pyjwt.decode(token, options={"verify_signature": False})
    except pyjwt.PyJWTError as exc:
        raise ValueError("Invalid Google ID token") from exc
    if not payload.get("email"):
        raise ValueError("Google ID token has no email claim")
    return payload
