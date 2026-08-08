-- Migration 001: Authentication upgrade.
-- Adds auth_provider (email/google), account status, updated_at and
-- email verification columns to flow_users.
--
-- Run with:
--   mysql -u flow_app -p flow_app < db/migrations/001_auth_upgrade.sql

ALTER TABLE flow_users
    ADD COLUMN auth_provider            VARCHAR(16)  NOT NULL DEFAULT 'email' AFTER email,
    ADD COLUMN status                   VARCHAR(16)  NOT NULL DEFAULT 'active' AFTER password_hash,
    ADD COLUMN email_verify_code_hash   VARCHAR(64)  NOT NULL DEFAULT '' AFTER is_verified,
    ADD COLUMN email_verify_expires_at  DATETIME     NULL AFTER email_verify_code_hash,
    ADD COLUMN updated_at               DATETIME     NULL AFTER last_login_at;

-- Existing seeded users were created with email/password auth.
UPDATE flow_users SET auth_provider = 'email' WHERE auth_provider = 'email';
