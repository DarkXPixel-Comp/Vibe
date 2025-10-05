package config

type AuthServiceConfig struct {
	Host string `env:"HOST" validate:"required"`
	Port int    `env:"PORT" validate:"required"`
}
