DROP TRIGGER IF EXISTS trg_private_pairs_chat_type ON private_chat_pairs;
DROP FUNCTION IF EXISTS ensure_private_chat_type();

DROP INDEX IF EXISTS private_chat_unique_pair_idx;
DROP TABLE IF EXISTS private_chat_pairs;

DROP INDEX IF EXISTS idx_chats_last_activity_at;
DROP INDEX IF EXISTS idx_memberships_user_id;
DROP TABLE IF EXISTS memberships;

DROP TABLE IF EXISTS chats;
