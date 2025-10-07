package config

import (
	"fmt"

	"github.com/caarlos0/env/v9"
	"github.com/go-playground/validator/v10"
	"github.com/joho/godotenv"
)

type Config struct {
	DB          DBConfig          `envPrefix:"DATABASE_"`
	GRPC        GRPCConfig        `envPrefix:"GRPC_"`
	Redis       RedisConfig       `envPrefix:"REDIS_"`
	JWT         JWTConfig         `envPrefix:"JWT_"`
	UserService UserServiceConfig `envPrefix:"USER_SERVICE_"`
	Session     SessionConfig     `envPrefix:"SESSION_"`
	//Loki        LokiConfig        `mapstructure:"loki"`
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
