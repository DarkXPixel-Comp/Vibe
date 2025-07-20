package config

import (
	"fmt"

	"github.com/go-playground/validator/v10"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
)

type Config struct {
	Postgresql  PostgresqlConfig  `mapstructure:"postgresql" validate:"required"`
	GRPCConfig  GRPCConfig        `mapstructure:"grpc" validate:"required"`
	AuthService AuthServiceConfig `mapstructure:"auth-service" validate:"required"`
}

func LoadConfig() (*Config, error) {
	godotenv.Load("../.env")
	viper.AutomaticEnv()

	configPath := viper.GetString("CONFIG_PATH")
	if configPath == "" {
		configPath = "./config"
	}

	appEnv := viper.GetString("APP_ENV")
	if appEnv == "" {
		appEnv = "local"
	}

	viper.SetConfigName(appEnv)
	viper.SetConfigType("yaml")
	viper.AddConfigPath(configPath)

	if err := viper.ReadInConfig(); err != nil {
		return nil, fmt.Errorf("error reading config file: %w", err)
	}

	var cfg Config
	if err := viper.Unmarshal(&cfg); err != nil {
		return nil, fmt.Errorf("unable to decode into struct: %w", err)
	}

	validate := validator.New()
	if err := validate.Struct(&cfg); err != nil {
		if validationErrors, ok := err.(validator.ValidationErrors); ok {
			for _, fieldErr := range validationErrors {
				fmt.Printf("Field validation error: Field '%s' failed on the '%s' tag\n", fieldErr.Field(), fieldErr.Tag())
			}
		}
		return nil, fmt.Errorf("config validation failed: %w", err)
	}

	return &cfg, nil
}
