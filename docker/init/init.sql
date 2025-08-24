CREATE USER auth_user WITH PASSWORD 'auth_pass';
CREATE USER user_user WITH PASSWORD 'user_pass';
CREATE USER chat_user WITH PASSWORD 'chat_pass';
CREATE USER sync_user WITH PASSWORD 'sync_pass';

CREATE USER admin_user WITH PASSWORD 'admin_pass' SUPERUSER;

CREATE DATABASE vibe_auth OWNER auth_user;
CREATE DATABASE vibe_user OWNER user_user;
CREATE DATABASE vibe_chat OWNER chat_user;
CREATE DATABASE vibe_sync OWNER sync_user;

GRANT ALL PRIVILEGES ON DATABASE vibe_auth TO auth_user;
GRANT ALL PRIVILEGES ON DATABASE vibe_user TO user_user;
GRANT ALL PRIVILEGES ON DATABASE vibe_chat TO chat_user;
GRANT ALL PRIVILEGES ON DATABASE vibe_sync TO sync_user;