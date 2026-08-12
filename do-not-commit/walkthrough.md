# Walkthrough: Internal Developer Platform (IDP)

## What Was Built
A complete Internal Developer Platform PoC demonstrating the Provisioning → Delivery → Abstraction lifecycle.

## Files Created
- `terraform/main.tf` — EKS cluster + ArgoCD Helm release
- `terraform/variables.tf` — Configurable region and cluster name
- `terraform/outputs.tf` — Cluster endpoint and security group outputs
- `argocd-gitops/app-project.yaml` — ArgoCD AppProject CRD
- `argocd-gitops/root-application.yaml` — Root App of Apps with auto-sync
- `backstage-portal/app-config.yaml` — Backstage config pointing to local templates
- `golden-path-templates/nodejs-microservice/template.yaml` — Scaffolder template
- `golden-path-templates/nodejs-microservice/skeleton/` — Generated app skeleton
- `README.md` — Landing-page style overview
- `docs/ARCHITECTURE.md` — Deep dive into platform concepts

## How It Works
1. Terraform provisions EKS and bootstraps ArgoCD via Helm
2. ArgoCD watches the gitops directory for new applications
3. Backstage provides a UI where developers create new services from templates
4. Templates generate repos with Dockerfiles + K8s manifests → ArgoCD auto-deploys
