package config

type PostgresConfig struct {
	Host     string `env:"HOST" validate:"required"`
	Port     string `env:"PORT" validate:"required"`
	User     string `env:"USER" validate:"required"`
	Password string `env:"PASSWORD" validate:"required"`
	DBName   string `env:"DBNAME" validate:"required"`
	SSLMode  string `env:"SSLMODE" validate:"required"`
}
