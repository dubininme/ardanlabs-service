# Define dependencies

GOLANG          := golang:1.26
ALPINE          := alpine:3.23
KIND            := kindest/node:v1.35.0
POSTGRES        := postgres:18.3
GRAFANA         := grafana/grafana:12.4.0
PROMETHEUS      := prom/prometheus:v3.10.0
TEMPO           := grafana/tempo:2.10.0
LOKI            := grafana/loki:3.6.0
PROMTAIL        := grafana/promtail:3.6.0

KIND_CLUSTER    := ardan-starter-cluster
NAMESPACE       := sales-system
SALES_APP       := sales
AUTH_APP        := auth
BASE_IMAGE_NAME := localhost/ardanlabs
VERSION         := 0.0.1
SALES_IMAGE     := $(BASE_IMAGE_NAME)/$(SALES_APP):$(VERSION)
METRICS_IMAGE   := $(BASE_IMAGE_NAME)/metrics:$(VERSION)
AUTH_IMAGE      := $(BASE_IMAGE_NAME)/$(AUTH_APP):$(VERSION)

# VERSION       := "0.0.1-$(shell git rev-parse --short HEAD)"

run:
	go run apis/services/sales/main.go | go run apis/tooling/logfmt/main.go

tidy:
	go mod tidy
	go mod vendor

dev-up:
	kind create cluster \
		--image $(KIND) \
		--name $(KIND_CLUSTER) \
		--config zarf/k8s/dev/kind-config.yaml

	kubectl wait --timeout=120s --namespace=local-path-storage --for=condition=Available deployment/local-path-provisioner

# 	kind load docker-image $(POSTGRES) --name $(KIND_CLUSTER)
# 	kind load docker-image $(GRAFANA) --name $(KIND_CLUSTER)
# 	kind load docker-image $(PROMETHEUS) --name $(KIND_CLUSTER)
# 	kind load docker-image $(TEMPO) --name $(KIND_CLUSTER)
# 	kind load docker-image $(LOKI) --name $(KIND_CLUSTER)
# 	kind load docker-image $(PROMTAIL) --name $(KIND_CLUSTER)

dev-down:
	kind delete cluster --name $(KIND_CLUSTER)

dev-status-all:
	kubectl get nodes -o wide
	kubectl get svc -o wide
	kubectl get pods -o wide --watch --all-namespaces

dev-status:
	watch -n 2 kubectl get pods -o wide --all-namespaces