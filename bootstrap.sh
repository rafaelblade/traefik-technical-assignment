#!/usr/bin/env bash
set -euo pipefail

APP_NAME="foobar-api"
IMAGE_NAME="foobar-api:local"
PVC_NAME="foobar-api-certs"
SECRET_NAME="foobar-api-tls"
CERT_DIR="./certs"

echo "Generate self-signed certs"
mkdir -p "$CERT_DIR"
if [ ! -f "$CERT_DIR/tls.crt" ] || [ ! -f "$CERT_DIR/tls.key" ]; then
    echo "Generating self-signed certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$CERT_DIR/tls.key" \
        -out "$CERT_DIR/tls.crt" \
        -subj "/CN=foobar.local/O=foobar"
else
    echo "Certificates already exist, skipping generation."
fi

echo "Create TLS Secret"
kubectl get secret "$SECRET_NAME" >/dev/null 2>&1 || \
kubectl create secret generic "$SECRET_NAME" \
    --from-file=tls.crt="$CERT_DIR/tls.crt" \
    --from-file=tls.key="$CERT_DIR/tls.key"

echo "Build Docker image"
if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    docker build -t "$IMAGE_NAME" foobar-api/
    kind load docker-image "$IMAGE_NAME"
else
    echo "Docker image $IMAGE_NAME already exists, skipping build."
fi

echo "Install Traefik via Helm"
helm repo add traefik https://traefik.github.io/charts >/dev/null
helm repo update >/dev/null
helm upgrade --install traefik traefik/traefik \
    --namespace "traefik" \
    --values k8s/traefik/values.yaml \
    --create-namespace

echo "Deploy Foobar API"
kubectl apply -f k8s/app/pvc.yaml
kubectl apply -f k8s/app/deployment.yaml
kubectl apply -f k8s/app/service.yaml
kubectl apply -f k8s/app/ingressroute.yaml

echo "Verify Deployment"
kubectl get pods 
kubectl get svc 
kubectl get ingressroutetcp
