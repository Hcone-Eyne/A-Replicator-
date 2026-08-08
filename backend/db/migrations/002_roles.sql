-- Migration 002: User roles.
-- Adds a role column (user | seller | admin) to flow_users.
--
-- Run with:
--   mysql -u flow_app -p flow_app < db/migrations/002_roles.sql

ALTER TABLE flow_users
    ADD COLUMN role VARCHAR(16) NOT NULL DEFAULT 'user' AFTER status;

-- Promote existing seeded sellers (users who already own listings).
UPDATE flow_users u
    JOIN flow_listings l ON l.seller_id = u.id
    SET u.role = 'seller'
    WHERE u.role = 'user';
