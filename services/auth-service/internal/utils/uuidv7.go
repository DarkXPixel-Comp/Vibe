package utils

import (
	"crypto/rand"
	"encoding/binary"
	"fmt"
	"time"
)

func UUIDv7() (string, error) {
	var b [16]byte

	// 48 бит времени в миллисекундах
	ts := uint64(time.Now().UnixMilli()) & 0xFFFFFFFFFFFF
	b[0] = byte(ts >> 40)
	b[1] = byte(ts >> 32)
	b[2] = byte(ts >> 24)
	b[3] = byte(ts >> 16)
	b[4] = byte(ts >> 8)
	b[5] = byte(ts)

	// 4 бита версии (7) + оставшиеся 4 бита случайные
	_, err := rand.Read(b[6:16])
	if err != nil {
		return "", err
	}

	b[6] = (b[6] & 0x0F) | 0x70 // версия 7
	b[8] = (b[8] & 0x3F) | 0x80 // variant RFC4122

	uuid := fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		binary.BigEndian.Uint32(b[0:4]),
		binary.BigEndian.Uint16(b[4:6]),
		binary.BigEndian.Uint16(b[6:8]),
		binary.BigEndian.Uint16(b[8:10]),
		b[10:16],
	)

	return uuid, nil
}
