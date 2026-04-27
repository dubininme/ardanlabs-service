// Package web contains a small web framework extension.
package web

import (
	"context"
	"net/http"
	"os"
)

type App struct {
	*http.ServeMux
	mw       []MidHandler
	shutdown chan os.Signal
}

func NewApp(shutdown chan os.Signal, mv ...MidHandler) *App {
	return &App{
		ServeMux: http.NewServeMux(),
		shutdown: shutdown,
		mw:       mv,
	}
}

type Handler func(ctx context.Context, w http.ResponseWriter, r *http.Request) error

func (a *App) HandleFunc(pattern string, handler Handler, mw ...MidHandler) {
	handler = wrapMiddleware(mw, handler)
	handler = wrapMiddleware(a.mw, handler)

	h := func(w http.ResponseWriter, r *http.Request) {
		handler(r.Context(), w, r)
	}

	a.ServeMux.HandleFunc(pattern, h)
}
