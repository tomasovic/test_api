# Kubernetes Manifests for Test API

This directory contains Kubernetes manifests for deploying the Test API application.

## Manifests

- `deployment.yaml`: Deploys the application using the GitHub container image
- `service.yaml`: Exposes the application internally
- `ingress.yaml`: Exposes the application externally
- `github-registry-secret.yaml`: Secret for pulling images from GitHub Container Registry

## Usage

These manifests are meant to be applied by ArgoCD for GitOps-based deployments.
