package config

type JWTConfig struct {
	Secret string `mapstructure:"secret" validate:"required"`
}
