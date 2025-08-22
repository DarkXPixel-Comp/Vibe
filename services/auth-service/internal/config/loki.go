package config

type LokiConfig struct {
	Host string `mapstructure:"host"`
	Port int    `mapstructure:"port"`
}
