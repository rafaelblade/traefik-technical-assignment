# Traefik Technical Assignment

## Objective

Deploy the `foobar-api` application in Kubernetes and expose it securely via HTTPS using Traefik.  
TLS certificates must be stored in a Persistent Volume Claim (PVC), and TLS termination happens **inside the application container** (Traefik is configured in passthrough mode).

## Architecture Overview

The deployment architecture:

- **foobar-api** deployed as a **Deployment**  
- Exposed via a **ClusterIP Service**  
- **Traefik** deployed as the **Ingress Controller** in **TLS passthrough mode**  
- **TLS termination** occurs inside the foobar-api container using certificates mounted from a **PVC**  

## Prerequisites

- Kubernetes cluster (tested with [kind](https://kind.sigs.k8s.io/))  
- `kubectl` installed and configured  
- `helm` installed  

## Repository Structure

.
├── bootstrap.sh # Script to bootstrap the Kubernetes environment
├── docs # Additional documentation (architecture, diagrams, notes)
├── foobar-api # Application source code and Dockerfile
│ ├── app.go
│ ├── Dockerfile
│ ├── go.mod
│ ├── go.sum
│ ├── LICENSE
│ ├── Makefile
│ └── README.md
├── k8s # Kubernetes manifests and certificates
│ ├── app
│ │ ├── deployment.yaml
│ │ ├── ingressroute.yaml
│ │ ├── pvc.yaml
│ │ └── service.yaml
│ ├── certs
│ │ ├── cert.pem
│ │ └── key.pem
│ └── traefik
│ ├── dashboard-ingress.yaml
│ └── values.yaml
├── kind-config.yaml # Configuration file for kind cluster
└── README.md # This README

## Deployment

1. Make the bootstrap script executable:

chmod +x bootstrap.sh

2. Run the deployment script:

./bootstrap.sh
