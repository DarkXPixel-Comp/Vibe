package config

type RedisConfig struct {
	Host     string `mapstructure:"host" validate:"required"`
	Port     string `mapstructure:"port" validate:"required"`
	Passowrd string `mapstructure:"password"`
}
