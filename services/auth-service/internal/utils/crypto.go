package utils

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"fmt"
	"io"
)

// GenerateRandomKey creates a random key of the specified size.
func GenerateRandomKey(size int) ([]byte, error) {
	key := make([]byte, size)
	if _, err := rand.Read(key); err != nil {
		return nil, err
	}
	return key, nil
}

// Encrypt encrypts data using AES-GCM.
func Encrypt(data, key []byte) ([]byte, error) {
	// The key must be 32 bytes for AES-256.
	if len(key) != 32 {
		return nil, fmt.Errorf("encryption key must be 32 bytes")
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}

	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return nil, err
	}

	return gcm.Seal(nonce, nonce, data, nil), nil
}

// Decrypt decrypts data using AES-GCM.
func Decrypt(data, key []byte) ([]byte, error) {
	// The key must be 32 bytes for AES-256.
	if len(key) != 32 {
		return nil, fmt.Errorf("decryption key must be 32 bytes")
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}

	if len(data) < gcm.NonceSize() {
		return nil, fmt.Errorf("ciphertext too short")
	}

	nonce, ciphertext := data[:gcm.NonceSize()], data[gcm.NonceSize():]
	return gcm.Open(nil, nonce, ciphertext, nil)
}