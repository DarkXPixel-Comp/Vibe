DROP INDEX IF EXISTS idx_chat_users_chat_id;
DROP INDEX IF EXISTS idx_chat_users_user_id;

DROP TABLE IF EXISTS chat_users;
DROP TABLE IF EXISTS chats;

DROP TYPE IF EXISTS chat_user_status;
DROP TYPE IF EXISTS chat_user_role;
DROP TYPE IF EXISTS chat_type;
