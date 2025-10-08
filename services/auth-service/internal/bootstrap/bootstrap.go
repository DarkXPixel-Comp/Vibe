package bootstrap

import (
	"fmt"
	"log"
	"os"

	"github.com/DarkXPixel/Vibe/services/auth-service/internal/utils"
)

type ServerKeys struct {
	Priv []byte
	Pub  []byte
	Ver  uint64
}

func LoadServerKeys() (*ServerKeys, error) {
	dir := os.Getenv("SERVER_KEYS_DIR")
	if dir == "" {
		dir = "/var/lib/auth-service"
	}

	mat, err := utils.LoadOrGenerate(dir, 1)
	if err != nil {
		return nil, err
	}

	if len(mat.Priv) != 32 || len(mat.Pub) != 32 {
		return nil, fmt.Errorf("bad key size")
	}

	return &ServerKeys{
		Priv: mat.Priv,
		Pub:  mat.Pub,
		Ver:  mat.KeyVersion,
	}, nil
}

func MustLoadServerKeys() *ServerKeys {
	k, err := LoadServerKeys()
	if err != nil {
		log.Fatalf("failed to load server keys: %v", err)
	}
	return k
}
