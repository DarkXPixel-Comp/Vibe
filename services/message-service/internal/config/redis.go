package config

type RedisConfig struct {
	Host     string `mapstructure:"host" validate:"required"`
	Port     int    `mapstructure:"port" validate:"required"`
	Password string `mapstructure:"password" validate:"required"`
	DB       int    `mapstructure:"db"`
}
