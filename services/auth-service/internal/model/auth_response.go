package model

type AuthResponse struct {
	Token      string
	User_id    string
	SessionKey []byte
}