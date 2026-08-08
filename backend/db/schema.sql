-- Flow App MySQL schema (utf8mb4)
-- Mirrors the freezed models in lib/features/*/data/models/

CREATE TABLE IF NOT EXISTS flow_users (
    id              VARCHAR(64)  NOT NULL PRIMARY KEY,
    username        VARCHAR(64)  NOT NULL UNIQUE,
    name            VARCHAR(255) NOT NULL,
    email           VARCHAR(255) NOT NULL UNIQUE,
    auth_provider   VARCHAR(16)  NOT NULL DEFAULT 'email',
    phone           VARCHAR(32)  NOT NULL DEFAULT '',
    password_hash   VARCHAR(255) NOT NULL DEFAULT '',
    status          VARCHAR(16)  NOT NULL DEFAULT 'active',
    avatar_url      VARCHAR(1024) NOT NULL DEFAULT '',
    is_verified     BOOLEAN      NOT NULL DEFAULT FALSE,
    email_verify_code_hash  VARCHAR(64) NOT NULL DEFAULT '',
    email_verify_expires_at DATETIME     NULL,
    location        VARCHAR(255) NOT NULL DEFAULT '',
    rating          DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    reviews_count   INT          NOT NULL DEFAULT 0,
    listings_count  INT          NOT NULL DEFAULT 0,
    sales_count     INT          NOT NULL DEFAULT 0,
    bio             TEXT         NULL,
    member_duration VARCHAR(64)  NOT NULL DEFAULT '',
    positive_percent DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    last_login_at   DATETIME     NULL,
    updated_at      DATETIME     NULL,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_refresh_tokens (
    id           VARCHAR(64)   NOT NULL PRIMARY KEY,
    user_id      VARCHAR(64)   NOT NULL,
    token_hash   VARCHAR(64)   NOT NULL UNIQUE,
    expires_at   DATETIME      NOT NULL,
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    revoked_at   DATETIME      NULL,
    replaced_by  VARCHAR(64)   NULL,
    CONSTRAINT fk_refresh_user FOREIGN KEY (user_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    INDEX idx_refresh_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_password_resets (
    id           VARCHAR(64)   NOT NULL PRIMARY KEY,
    user_id      VARCHAR(64)   NOT NULL,
    token_hash   VARCHAR(64)   NOT NULL UNIQUE,
    expires_at   DATETIME      NOT NULL,
    used_at      DATETIME      NULL,
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reset_user FOREIGN KEY (user_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    INDEX idx_reset_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_otp_codes (
    id           VARCHAR(64)   NOT NULL PRIMARY KEY,
    phone        VARCHAR(32)   NOT NULL,
    code_hash    VARCHAR(64)   NOT NULL,
    expires_at   DATETIME      NOT NULL,
    attempts     INT           NOT NULL DEFAULT 0,
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_otp_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_user_follows (
    follower_id VARCHAR(64) NOT NULL,
    followee_id VARCHAR(64) NOT NULL,
    created_at  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, followee_id),
    CONSTRAINT fk_follows_follower FOREIGN KEY (follower_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_follows_followee FOREIGN KEY (followee_id) REFERENCES flow_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_categories (
    id    VARCHAR(64)  NOT NULL PRIMARY KEY,
    name  VARCHAR(64)  NOT NULL,
    icon  VARCHAR(64)  NOT NULL DEFAULT 'other',
    count INT          NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_listings (
    id             VARCHAR(64)   NOT NULL PRIMARY KEY,
    seller_id      VARCHAR(64)   NOT NULL,
    title          VARCHAR(255)  NOT NULL DEFAULT '',
    description    TEXT          NULL,
    price          DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    currency       VARCHAR(8)    NOT NULL DEFAULT 'NGN',
    images         JSON          NOT NULL,
    category       VARCHAR(64)   NOT NULL,
    subcategory    VARCHAR(64)   NOT NULL DEFAULT '',
    status         VARCHAR(16)   NOT NULL DEFAULT 'active',
    created_at     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_featured    BOOLEAN       NOT NULL DEFAULT FALSE,
    view_count     INT           NOT NULL DEFAULT 0,
    favorite_count INT           NOT NULL DEFAULT 0,
    item_condition VARCHAR(32)   NOT NULL DEFAULT '',
    location       VARCHAR(255)  NOT NULL DEFAULT '',
    CONSTRAINT fk_listings_seller FOREIGN KEY (seller_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    INDEX idx_listings_category (category),
    INDEX idx_listings_status (status),
    INDEX idx_listings_seller (seller_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_favorites (
    user_id    VARCHAR(64) NOT NULL,
    listing_id VARCHAR(64) NOT NULL,
    created_at DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, listing_id),
    CONSTRAINT fk_favs_user FOREIGN KEY (user_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_favs_listing FOREIGN KEY (listing_id) REFERENCES flow_listings(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_orders (
    id               VARCHAR(64)   NOT NULL PRIMARY KEY,
    buyer_id         VARCHAR(64)   NOT NULL,
    seller_id        VARCHAR(64)   NOT NULL,
    listing_id       VARCHAR(64)   NOT NULL,
    listing_title    VARCHAR(255)  NOT NULL DEFAULT '',
    listing_image    VARCHAR(1024) NOT NULL DEFAULT '',
    price            DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    currency         VARCHAR(8)    NOT NULL DEFAULT 'NGN',
    status           VARCHAR(16)   NOT NULL DEFAULT 'pending',
    created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipping_address VARCHAR(512)  NOT NULL DEFAULT '',
    payment_method   VARCHAR(64)   NOT NULL DEFAULT '',
    is_paid          BOOLEAN       NOT NULL DEFAULT FALSE,
    quantity         INT           NOT NULL DEFAULT 1,
    CONSTRAINT fk_orders_buyer FOREIGN KEY (buyer_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_orders_seller FOREIGN KEY (seller_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_orders_listing FOREIGN KEY (listing_id) REFERENCES flow_listings(id) ON DELETE CASCADE,
    INDEX idx_orders_buyer (buyer_id),
    INDEX idx_orders_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_conversations (
    id                 VARCHAR(64)   NOT NULL PRIMARY KEY,
    user_a_id          VARCHAR(64)   NOT NULL,
    user_b_id          VARCHAR(64)   NOT NULL,
    last_message       TEXT          NULL,
    last_message_time  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    unread_count       INT           NOT NULL DEFAULT 0,
    is_online          BOOLEAN       NOT NULL DEFAULT FALSE,
    product_title      VARCHAR(255)  NOT NULL DEFAULT '',
    product_image      VARCHAR(1024) NOT NULL DEFAULT '',
    created_at         DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_conv_a FOREIGN KEY (user_a_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_conv_b FOREIGN KEY (user_b_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    UNIQUE KEY uq_conv_pair (user_a_id, user_b_id),
    INDEX idx_conv_user_a (user_a_id),
    INDEX idx_conv_user_b (user_b_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_messages (
    id              VARCHAR(64)   NOT NULL PRIMARY KEY,
    conversation_id VARCHAR(64)   NOT NULL,
    sender_id       VARCHAR(64)   NOT NULL,
    text            TEXT          NULL,
    image_url       VARCHAR(1024) NOT NULL DEFAULT '',
    timestamp       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_read         BOOLEAN       NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_msg_conv FOREIGN KEY (conversation_id) REFERENCES flow_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_msg_sender FOREIGN KEY (sender_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    INDEX idx_msg_conversation (conversation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_reviews (
    id          VARCHAR(64)   NOT NULL PRIMARY KEY,
    seller_id   VARCHAR(64)   NOT NULL,
    reviewer_id VARCHAR(64)   NULL,
    user_name   VARCHAR(255)  NOT NULL DEFAULT '',
    user_avatar VARCHAR(1024) NOT NULL DEFAULT '',
    rating      INT           NOT NULL DEFAULT 5,
    date        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    text        TEXT          NULL,
    has_photo   BOOLEAN       NOT NULL DEFAULT FALSE,
    photo_url   VARCHAR(1024) NOT NULL DEFAULT '',
    CONSTRAINT fk_reviews_seller FOREIGN KEY (seller_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    INDEX idx_reviews_seller (seller_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flow_notifications (
    id         VARCHAR(64)   NOT NULL PRIMARY KEY,
    user_id    VARCHAR(64)   NOT NULL,
    title      VARCHAR(255)  NOT NULL DEFAULT '',
    body       TEXT          NULL,
    type       VARCHAR(16)   NOT NULL DEFAULT 'system',
    is_read    BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data       JSON          NULL,
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES flow_users(id) ON DELETE CASCADE,
    INDEX idx_notif_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
