package config

type UserServiceConfig struct {
	Port int    `mapstructure:"port" validate:"required"`
	Host string `mapstructure:"host" validate:"required"`
}
