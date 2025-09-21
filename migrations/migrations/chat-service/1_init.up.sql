CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TYPE chat_type AS ENUM ('private', 'group', 'channel');
CREATE TYPE chat_user_role AS ENUM ('member', 'admin', 'owner');
CREATE TYPE chat_user_status AS ENUM ('active', 'left', 'banned');


CREATE TABLE IF NOT EXISTS chats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type chat_type NOT NULL,
    title TEXT, -- null for private
    creator_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS chat_users (
    chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    role chat_user_role NOT NULL DEFAULT 'member',
    status chat_user_status NOT NULL DEFAULT 'active',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    PRIMARY KEY (chat_id, user_id)
);


CREATE INDEX IF NOT EXISTS idx_chat_users_user_id ON chat_users(user_id);
CREATE INDEX IF NOT EXISTS idx_chat_users_chat_id ON chat_users(chat_id);
