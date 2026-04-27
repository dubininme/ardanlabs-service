package mux

import (
	"os"

	"github.com/dubininme/ardanlabs-service/apis/services/sales/route/sys/checkapi"
	"github.com/dubininme/ardanlabs-service/foundation/web"
)

func WebAPI(shutdown chan os.Signal) *web.App {
	mux := web.NewApp(shutdown)

	checkapi.Routes(mux)

	return mux
}
