module github.com/DarkXPixel/Vibe/services/auth-service

go 1.24.4

// require (
// 	github.com/DarkXPixel/Vibe/proto v0.0.0-00010101000000-000000000000
// 	google.golang.org/grpc v1.73.0
// )

require (
	buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go v1.5.1-20251008091707-44d3b3e0e2e2.2
	buf.build/gen/go/darkxpixel/vibe-contracts/protocolbuffers/go v1.36.10-20251008091707-44d3b3e0e2e2.1
	github.com/alicebob/miniredis v2.5.0+incompatible
	github.com/caarlos0/env/v9 v9.0.0
	github.com/envoyproxy/go-control-plane/envoy v1.35.0
	github.com/go-playground/validator/v10 v10.28.0
	github.com/golang-jwt/jwt/v5 v5.3.0
	github.com/jackc/pgx/v5 v5.7.6
	github.com/joho/godotenv v1.5.1
	github.com/nyaruka/phonenumbers v1.6.5
	github.com/pashagolub/pgxmock/v2 v2.12.0
	github.com/redis/go-redis/v9 v9.14.0
	github.com/stretchr/testify v1.11.1
	go.uber.org/mock v0.6.0
	google.golang.org/genproto/googleapis/rpc v0.0.0-20251007200510-49b9836ed3ff
	google.golang.org/grpc v1.76.0
)

require (
	github.com/alicebob/gopher-json v0.0.0-20230218143504-906a9b012302 // indirect
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/cncf/xds/go v0.0.0-20250501225837-2ac532fd4443 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/dgryski/go-rendezvous v0.0.0-20200823014737-9f7001d12a5f // indirect
	github.com/envoyproxy/protoc-gen-validate v1.2.1 // indirect
	github.com/gabriel-vasile/mimetype v1.4.10 // indirect
	github.com/go-playground/locales v0.14.1 // indirect
	github.com/go-playground/universal-translator v0.18.1 // indirect
	github.com/gomodule/redigo v1.9.2 // indirect
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20240606120523-5a60cdf6a761 // indirect
	github.com/jackc/puddle/v2 v2.2.2 // indirect
	github.com/kr/text v0.2.0 // indirect
	github.com/leodido/go-urn v1.4.0 // indirect
	github.com/planetscale/vtprotobuf v0.6.1-0.20240319094008-0393e58bdf10 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/rogpeppe/go-internal v1.14.1 // indirect
	github.com/yuin/gopher-lua v1.1.1 // indirect
	golang.org/x/crypto v0.42.0 // indirect
	golang.org/x/exp v0.0.0-20251002181428-27f1f14c8bb9 // indirect
	golang.org/x/net v0.45.0 // indirect
	golang.org/x/sync v0.17.0 // indirect
	golang.org/x/sys v0.36.0 // indirect
	golang.org/x/text v0.29.0 // indirect
	google.golang.org/protobuf v1.36.10 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

//replace github.com/DarkXPixel/Vibe/proto => ../../proto
