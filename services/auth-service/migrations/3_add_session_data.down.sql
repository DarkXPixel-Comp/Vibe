ALTER TABLE session_tokens
DROP COLUMN encrypted_session_key,
DROP COLUMN device_id,
DROP COLUMN device_name;