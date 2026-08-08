-- Migration 003: Per-user conversation unread counters + reviews uniqueness.
--
-- The single unread_count column was shared between both participants: any
-- sender's message incremented it, so a user saw their own messages as unread
-- and one participant marking the conversation read cleared the other side's
-- badge. Replace it with per-participant counters (user_a_unread /
-- user_b_unread) and enforce at the DB level that a buyer can review a seller
-- at most once (previously only checked in application code).
--
-- Run with:
--   mysql -u flow_app -p flow_app < db/migrations/003_conversation_unread_reviews_unique.sql

ALTER TABLE flow_conversations
    ADD COLUMN user_a_unread INT NOT NULL DEFAULT 0 AFTER last_message_time,
    ADD COLUMN user_b_unread INT NOT NULL DEFAULT 0 AFTER user_a_unread;

-- Backfill: the legacy shared counter represented messages awaiting the
-- reading participant; in all seeded data that reader was user_a.
UPDATE flow_conversations SET user_a_unread = unread_count;

ALTER TABLE flow_conversations DROP COLUMN unread_count;

-- One review per (seller, reviewer) pair. MySQL unique indexes treat NULL
-- reviewer_id values as distinct, so anonymous seeded reviews are unaffected.
ALTER TABLE flow_reviews
    ADD UNIQUE KEY uq_reviews_seller_reviewer (seller_id, reviewer_id);
