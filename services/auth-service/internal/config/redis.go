package config

type RedisConfig struct {
	Host     string `env:"HOST" validate:"required"`
	Port     string `env:"PORT" validate:"required"`
	Password string `env:"PASSWORD"`
}
