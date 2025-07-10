package utils

import (
	"crypto/rand"
	"fmt"

	"github.com/nyaruka/phonenumbers"
)

func GenerateSMSCode() (string, error) {
	const digits = "0123456789"
	const lenght = 5

	code := make([]byte, lenght)
	b := make([]byte, lenght)

	_, err := rand.Read(b)
	if err != nil {
		return "", fmt.Errorf("error generate code: %w", err)
	}

	for i := 0; i < lenght; i++ {
		code[i] = digits[int(b[i]%byte(len(digits)))]
	}
	return string(code), nil
}

func ValidatePhoneNumber(number string) (string, error) {
	num, err := phonenumbers.Parse(number, "")

	if err != nil {
		return "", fmt.Errorf("failed validate phone number: %w", err)
	}

	if phonenumbers.IsPossibleNumber(num) &&
		phonenumbers.IsValidNumberForRegion(num, "RU") &&
		phonenumbers.IsValidNumber(num) &&
		(phonenumbers.GetNumberType(num) == phonenumbers.MOBILE || phonenumbers.GetNumberType(num) == phonenumbers.FIXED_LINE_OR_MOBILE) {
		return number, nil
	}

	return "", fmt.Errorf("invalid phone number")
}
