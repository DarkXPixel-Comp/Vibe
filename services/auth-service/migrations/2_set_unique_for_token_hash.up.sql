DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE schemaname = 'public'
          AND tablename = 'session_tokens'
          AND indexname = 'unique_token_hash_idx'
    ) THEN
        CREATE UNIQUE INDEX unique_token_hash_idx ON session_tokens(token_hash);
    END IF;
END
$$;