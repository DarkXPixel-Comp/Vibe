package config

import (
	"fmt"

	"github.com/caarlos0/env/v9"
	"github.com/go-playground/validator/v10"
	"github.com/joho/godotenv"
)

type Config struct {
	DB          DBConfig          `envPrefix:"DATABASE_" validate:"required"`
	GRPC        GRPCConfig        `envPrefix:"GRPC_" validate:"required"`
	AuthService AuthServiceConfig `envPrefix:"AUTH_SERVICE_" validate:"required"`
}

func LoadConfig() (*Config, error) {
	cfg := &Config{}
	godotenv.Load("../.env")

	if err := env.Parse(cfg); err != nil {
		return nil, fmt.Errorf("failed to parse env varriables: %w", err)
	}

	validate := validator.New()
	if err := validate.Struct(cfg); err != nil {
		if validationErrors, ok := err.(validator.ValidationErrors); ok {
			for _, fieldErr := range validationErrors {
				fmt.Printf("field validation error: Field '%s' failed on the '%s' tag\n", fieldErr.Field(), fieldErr.Tag())
			}
		}
		return nil, fmt.Errorf("config validation failed: %w", err)
	}

	return cfg, nil
}
