-- migrations/001_extensions.sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- migrations/002_init.sql
CREATE TABLE devices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  platform TEXT NOT NULL,
  name TEXT NOT NULL,
  fingerprint TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_seen TIMESTAMPTZ
);

CREATE TABLE auth_keys (
  auth_key_id BIGINT PRIMARY KEY,
  user_id UUID NOT NULL,
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  auth_key_enc BYTEA NOT NULL,
  version INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  revoked_at TIMESTAMPTZ,
  revoked_reason TEXT
);

CREATE TABLE sessions (
  session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  auth_key_id BIGINT NOT NULL REFERENCES auth_keys(auth_key_id) ON DELETE CASCADE,
  salt BIGINT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  aead_cipher TEXT NOT NULL DEFAULT 'chacha20-poly1305',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_seen TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  revoked_at TIMESTAMPTZ,
  revoked_reason TEXT
);

-- migrations/003_indexes.sql
CREATE INDEX idx_auth_keys_user_active ON auth_keys (user_id, auth_key_id) WHERE revoked_at IS NULL;
CREATE INDEX idx_sessions_user_active ON sessions (user_id, status) WHERE status='active';
CREATE INDEX idx_sessions_last_seen ON sessions (last_seen DESC);
CREATE INDEX idx_devices_user ON devices (user_id);