CREATE EXTENSION IF NOT EXISTS pg_uuidv7;

CREATE TABLE chats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(), -- нужен генератор v7
    type TEXT NOT NULL CHECK (type IN ('private','group','channel')),
    title TEXT,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_activity_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


CREATE TABLE memberships (
    chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('member','admin','owner')),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (chat_id, user_id)
);

CREATE INDEX idx_memberships_user_id ON memberships(user_id);

CREATE TABLE private_chat_pair (
    chat_id UUID PRIMARY KEY REFERENCES chats(id) ON DELETE CASCADE,
    user1_id UUID NOT NULL,
    user2_id UUID NOT NULL,
    CONSTRAINT unique_user_pair UNIQUE (
        LEAST(user1_id, user2_id),
        GREATEST(user1_id, user2_id)
    )
);