package handler

import (
	"encoding/json"
	"net/http"

	"github.com/DarkXPixel/Vibe/services/auth-service/internal/service"
)

type HTTP struct {
	Svc *service.AuthService
}

func (h *HTTP) Routes(mux *http.ServeMux) {
	mux.HandleFunc("/auth/start", h.start)
}

func (h *HTTP) start(w http.ResponseWriter, r *http.Request) {
	var in struct{ Phone string }
	_ = json.NewDecoder(r.Body).Decode(&in)
	ip := r.Header.Get("X-Real-IP")
	if ip == "" {
		ip = r.Header.Get("X-Forwarded-For")
	}
	if ip == "" {
		ip = r.RemoteAddr
	}

	chId, retry, otp, err := h.Svc.SendVerificationCode(r.Context(), in.Phone, ip)
	if err != nil {
		http.Error(w, err.Error(), 429)
		return
	}
	println(otp)
	json.NewEncoder(w).Encode(map[string]any{"challenge_id": chId, "retry_after_seconds": retry})
}
