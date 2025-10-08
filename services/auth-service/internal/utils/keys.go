package utils

import (
	"encoding/hex"
	"errors"
	"fmt"
	"os"
	"path/filepath"
)

type Material struct {
	Priv       []byte // 32 bytes
	Pub        []byte // 32 bytes
	KeyVersion uint64 // для ротации
}

func LoadOrGenerate(dir string, version uint64) (*Material, error) {
	privPath := filepath.Join(dir, "server_priv.bin")
	pubPath := filepath.Join(dir, "server_pub.bin")
	verPath := filepath.Join(dir, "server_key_version.txt")

	// 1) Попытка загрузки из ENV
	if os.Getenv("SERVER_PRIV_HEX") != "" && os.Getenv("SERVER_PUB_HEX") != "" {
		priv, err := hex.DecodeString(os.Getenv("SERVER_PRIV_HEX"))
		if err != nil || len(priv) != 32 {
			return nil, errors.New("bad SERVER_PRIV_HEX")
		}
		pub, err := hex.DecodeString(os.Getenv("SERVER_PUB_HEX"))
		if err != nil || len(pub) != 32 {
			return nil, errors.New("bad SERVER_PUB_HEX")
		}
		return &Material{Priv: priv, Pub: pub, KeyVersion: version}, nil
	}

	// 2) Попытка загрузки из файлов
	if priv, pub, ver, ok := tryLoadFiles(privPath, pubPath, verPath); ok {
		return &Material{Priv: priv, Pub: pub, KeyVersion: ver}, nil
	}

	// 3) Генерация новой пары
	priv, pub, err := GenerateX25519KeyPair()
	if err != nil {
		return nil, err
	}

	// 4) Атомарное сохранение
	if err := atomicWrite(privPath, priv, 0600); err != nil {
		return nil, fmt.Errorf("save priv: %w", err)
	}
	if err := atomicWrite(pubPath, pub, 0644); err != nil {
		return nil, fmt.Errorf("save pub: %w", err)
	}
	if err := atomicWrite(verPath, []byte(fmt.Sprintf("%d", version)), 0644); err != nil {
		return nil, fmt.Errorf("save version: %w", err)
	}

	return &Material{Priv: priv, Pub: pub, KeyVersion: version}, nil
}

func tryLoadFiles(privPath, pubPath, verPath string) (priv, pub []byte, ver uint64, ok bool) {
	priv, err1 := os.ReadFile(privPath)
	pub, err2 := os.ReadFile(pubPath)
	verBytes, err3 := os.ReadFile(verPath)
	if err1 != nil || err2 != nil || err3 != nil || len(priv) != 32 || len(pub) != 32 {
		return nil, nil, 0, false
	}
	var v uint64
	_, err := fmt.Sscanf(string(verBytes), "%d", &v)
	if err != nil {
		return nil, nil, 0, false
	}
	return priv, pub, v, true
}

func atomicWrite(path string, data []byte, perm os.FileMode) error {
	tmp := path + ".tmp"
	if err := os.WriteFile(tmp, data, perm); err != nil {
		return err
	}
	return os.Rename(tmp, path)
}
