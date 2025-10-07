package config

type SessionConfig struct {
	EncryptionKey string `env:"ENCRYPTION_KEY,required"`
}