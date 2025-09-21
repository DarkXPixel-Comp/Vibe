CREATE EXTENSION IF NOT EXISTS "pgcrypto";


CREATE TABLE user_sync (
    user_id VARCHAR(36) PRIMARY KEY,
    pts BIGINT NOT NULL DEFAULT 0,        -- Ordered updates (messages, chats)
    unordered_pts BIGINT NOT NULL DEFAULT 0 -- Unordered updates (profile)
);

CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id VARCHAR(36) NOT NULL,
    type VARCHAR(50) NOT NULL,            -- message, chat, profile, delete
    payload JSONB NOT NULL,
    pts BIGINT NOT NULL DEFAULT 0,
    unordered_pts BIGINT NOT NULL DEFAULT 0,
    timestamp TIMESTAMP NOT NULL
);
CREATE INDEX idx_events_user_id_pts ON events (user_id, pts);
CREATE INDEX idx_events_user_id_unordered_pts ON events (user_id, unordered_pts);