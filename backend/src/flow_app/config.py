"""Flow App API configuration.

Values can be overridden via environment variables or a backend/.env file.
All variables use the FLOW_ prefix, e.g. FLOW_DATABASE_URL.
"""
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_prefix="FLOW_",
        extra="ignore",
    )

    database_url: str = "mysql+pymysql://flow_app:flow_dev_password@localhost:3306/flow_app"
    current_user_id: str = "user_001"
    # When true (dev default), requests without a Bearer token act as
    # current_user_id. Disable in production so every request needs credentials.
    impersonation_enabled: bool = True
    cors_origins: str = "*"
    upload_dir: str = "backend/uploads"

    jwt_secret_key: str = "flow-dev-secret-key-change-me-in-production"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 60
    refresh_token_expire_days: int = 30
    reset_token_expire_minutes: int = 60
    otp_expire_minutes: int = 10
    email_verify_expire_minutes: int = 10

    # Google Sign-In. Comma-separated list of accepted OAuth2 client ids:
    # include the Web client id (used by the web app and as the Android
    # serverClientId), the iOS client id, and the Android client id if the
    # Android app does not set a serverClientId.
    # While it is empty, id tokens are trusted in dev (claims decoded unverified),
    # so the Google flow works without real Google credentials.
    google_client_id: str = ""
    google_allow_unverified: bool = True

    @property
    def google_client_ids(self) -> list[str]:
        return [
            cid.strip()
            for cid in self.google_client_id.split(",")
            if cid.strip()
        ]

    # Email delivery. When smtp_host is empty, outgoing email is logged to the
    # console (dev mode) instead of being sent.
    smtp_host: str = ""
    smtp_port: int = 587
    smtp_user: str = ""
    smtp_password: str = ""
    smtp_from: str = "Flow App <no-reply@flow.local>"


settings = Settings()
