package config

type JWTConfig struct {
	Secret string `env:"SECRET" validate:"required"`
}
