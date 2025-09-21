module github.com/DarkXPixel/Vibe/services/auth-service

go 1.24.4

// require (
// 	github.com/DarkXPixel/Vibe/proto v0.0.0-00010101000000-000000000000
// 	google.golang.org/grpc v1.73.0
// )

require (
	github.com/DarkXPixel/Vibe/proto v0.0.0-20250627202243-b346b288c9c5
	github.com/go-playground/validator/v10 v10.27.0
	github.com/golang-jwt/jwt/v5 v5.2.2
	github.com/jackc/pgx/v5 v5.7.5
	github.com/joho/godotenv v1.5.1
	github.com/nyaruka/phonenumbers v1.6.3
	github.com/redis/go-redis/v9 v9.11.0
	github.com/spf13/viper v1.20.1
	google.golang.org/grpc v1.73.0
)

require (
	cel.dev/expr v0.23.0 // indirect
	github.com/caarlos0/env/v9 v9.0.0 // indirect
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/cncf/xds/go v0.0.0-20250326154945-ae57f3c0d45f // indirect
	github.com/dgryski/go-rendezvous v0.0.0-20200823014737-9f7001d12a5f // indirect
	github.com/envoyproxy/go-control-plane v0.13.4 // indirect
	github.com/envoyproxy/go-control-plane/envoy v1.32.4 // indirect
	github.com/envoyproxy/protoc-gen-validate v1.2.1 // indirect
	github.com/fsnotify/fsnotify v1.8.0 // indirect
	github.com/gabriel-vasile/mimetype v1.4.8 // indirect
	github.com/go-playground/locales v0.14.1 // indirect
	github.com/go-playground/universal-translator v0.18.1 // indirect
	github.com/go-viper/mapstructure/v2 v2.2.1 // indirect
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20240606120523-5a60cdf6a761 // indirect
	github.com/jackc/puddle/v2 v2.2.2 // indirect
	github.com/leodido/go-urn v1.4.0 // indirect
	github.com/pelletier/go-toml/v2 v2.2.3 // indirect
	github.com/planetscale/vtprotobuf v0.6.1-0.20240319094008-0393e58bdf10 // indirect
	github.com/rogpeppe/go-internal v1.14.1 // indirect
	github.com/sagikazarmark/locafero v0.7.0 // indirect
	github.com/sourcegraph/conc v0.3.0 // indirect
	github.com/spf13/afero v1.12.0 // indirect
	github.com/spf13/cast v1.7.1 // indirect
	github.com/spf13/pflag v1.0.6 // indirect
	github.com/subosito/gotenv v1.6.0 // indirect
	go.uber.org/multierr v1.10.0 // indirect
	golang.org/x/crypto v0.37.0 // indirect
	golang.org/x/exp v0.0.0-20250305212735-054e65f0b394 // indirect
	golang.org/x/net v0.38.0 // indirect
	golang.org/x/sync v0.15.0 // indirect
	golang.org/x/sys v0.33.0 // indirect
	golang.org/x/text v0.26.0 // indirect
	google.golang.org/genproto/googleapis/api v0.0.0-20250324211829-b45e905df463 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20250324211829-b45e905df463 // indirect
	google.golang.org/protobuf v1.36.6 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

//replace github.com/DarkXPixel/Vibe/proto => ../../proto
