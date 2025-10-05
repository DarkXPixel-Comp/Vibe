package config

type GRPCConfig struct {
	Port int `env:"PORT" validate:"required"`
}
