package utils

import (
	"crypto/rand"
	"fmt"
)

func RandOTP() string {
	var b [4]byte
	_, _ = rand.Read(b[:])
	return fmt.Sprintf("%06d", (int(b[0])<<24|int(b[1])<<16|int(b[2])<<8|int(b[3]))%1000000)
}
