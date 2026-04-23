run:
	go run apis/services/sales/main.go | go run apis/tooling/logfmt/main.go

tidy:
	go mod tidy
	go mod vendor