package utils

import (
	"fmt"

	"github.com/nyaruka/phonenumbers"
)

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
