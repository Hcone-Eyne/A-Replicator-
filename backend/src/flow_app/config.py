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
    cors_origins: str = "*"
    upload_dir: str = "backend/uploads"


settings = Settings()
