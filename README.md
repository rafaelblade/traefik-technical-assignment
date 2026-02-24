# Traefik Technical Assignment

## Objective

Deploy the foobar-api application and expose it securely via HTTPS using Traefik.

Certificates must be stored in a Persistent Volume Claim (PVC).

## Planned Architecture

- foobar-api deployed as a Deployment
- ClusterIP Service
- Traefik deployed as Ingress Controller
- TLS termination handled by Traefik
- Certificates mounted from a PVC
