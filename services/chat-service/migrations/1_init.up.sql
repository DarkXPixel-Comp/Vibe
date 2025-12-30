CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE chats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type TEXT NOT NULL CHECK (type IN ('private','group','channel')),
    title TEXT,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_activity_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Индекс для быстрых выборок по последней активности
CREATE INDEX idx_chats_last_activity_at ON chats(last_activity_at DESC);

CREATE TABLE memberships (
    chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('member','admin','owner')),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (chat_id, user_id)
);

CREATE INDEX idx_memberships_user_id ON memberships(user_id);

CREATE TABLE private_chat_pairs (
    chat_id UUID PRIMARY KEY REFERENCES chats(id) ON DELETE CASCADE,
    user1_id UUID NOT NULL,
    user2_id UUID NOT NULL,
    CHECK (user1_id <> user2_id)
);

-- Гарантирует уникальность пары (user1_id, user2_id) без учета порядка
CREATE UNIQUE INDEX private_chat_unique_pair_idx
    ON private_chat_pairs (
        LEAST(user1_id, user2_id),
    GREATEST(user1_id, user2_id)
    );

-- Enforce that private_chat_pairs.chat_id references a private chat
CREATE OR REPLACE FUNCTION ensure_private_chat_type()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM chats WHERE id = NEW.chat_id AND type = 'private'
    ) THEN
        RAISE EXCEPTION 'chat_id % must reference a private chat', NEW.chat_id
            USING ERRCODE = 'check_violation';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_private_pairs_chat_type
BEFORE INSERT OR UPDATE OF chat_id ON private_chat_pairs
FOR EACH ROW
EXECUTE FUNCTION ensure_private_chat_type();
