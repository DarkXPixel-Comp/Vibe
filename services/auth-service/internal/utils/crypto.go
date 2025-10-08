package utils

import (
	"crypto/cipher"
	"crypto/ecdh"
	"crypto/rand"
	"crypto/sha1"
	"crypto/sha256"
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"io"

	"golang.org/x/crypto/chacha20poly1305"
	"golang.org/x/crypto/hkdf"
)

func GenerateX25519KeyPair() (priv, pub []byte, err error) {
	curve := ecdh.X25519()
	privKey, err := curve.GenerateKey(rand.Reader)
	if err != nil {
		return nil, nil, err
	}
	return privKey.Bytes(), privKey.PublicKey().Bytes(), nil
}
func ECDH_X25519(priv, peerPub []byte) ([]byte, error) {
	curve := ecdh.X25519()
	privKey, err := curve.NewPrivateKey(priv)
	if err != nil {
		return nil, err
	}

	pubKey, err := curve.NewPublicKey(peerPub)
	if err != nil {
		return nil, err
	}
	secret, err := privKey.ECDH(pubKey)
	if err != nil {
		return nil, err
	}
	return secret, nil
}

func HKDF_SHA256(secret, salt, info []byte, lenght int) ([]byte, error) {
	hk := hkdf.New(sha256.New, secret, salt, info)
	out := make([]byte, lenght)
	if _, err := io.ReadFull(hk, out); err != nil {
		return nil, fmt.Errorf("HKDF failed: %v", err)
	}
	return out, nil
}

func AuthKeyID(authKey []byte) uint64 {
	h := sha1.Sum(authKey)
	return binary.LittleEndian.Uint64(h[len(h)-8:])
}

func NewAEAD(key []byte) (cipher.AEAD, error) {
	return chacha20poly1305.New(key)
}

func AEADEncrypt(aead cipher.AEAD, nonce, aad, plaintext []byte) []byte {
	return aead.Seal(nil, nonce, plaintext, aad)
}

func AEADDecrypt(aead cipher.AEAD, nonce, aad, ciphertext []byte) ([]byte, error) {
	return aead.Open(nil, nonce, ciphertext, aad)
}

func HexSHA256(data []byte) string {
	h := sha256.Sum256(data)
	return hex.EncodeToString(h[:])
}

func RandUint64() (uint64, error) {
	var b [8]byte
	if _, err := rand.Read(b[:]); err != nil {
		return 0, err
	}
	return binary.LittleEndian.Uint64(b[:]), nil
}

func RandBytes(n int) ([]byte, error) {
	b := make([]byte, n)
	if _, err := rand.Read(b); err != nil {
		return nil, err
	}
	return b, nil
}
