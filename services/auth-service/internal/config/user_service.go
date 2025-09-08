package config

type UserServiceConfig struct {
	Port string `env:"PORT" validate:"required"`
	Host string `env:"HOST" validate:"required"`
}
