package checkapi

import "github.com/dubininme/ardanlabs-service/foundation/web"

func Routes(mux *web.App) {
	mux.HandleFunc("GET /liveness", liveness)
	mux.HandleFunc("GET /readiness", readiness)
}
