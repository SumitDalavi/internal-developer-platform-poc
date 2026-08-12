# Implementation Plan: Internal Developer Platform (IDP)

## Problem Statement
Platform Engineering is the #1 evolution in DevOps tooling. This PoC demonstrates a modern IDP combining Backstage, ArgoCD GitOps, and Terraform provisioning with "golden path" templates for developer self-service.

## Architecture Decisions
- **Backstage** as developer portal (industry standard, CNCF adopted)
- **ArgoCD** for GitOps delivery (App of Apps pattern)
- **Terraform** for IaC targeting AWS EKS
- **Golden Path Templates** to scaffold microservices with pre-wired CI/CD and K8s manifests

## Key Components
1. `terraform/` — EKS provisioning + ArgoCD Helm bootstrap
2. `argocd-gitops/` — Declarative "App of Apps" workload management
3. `backstage-portal/` — Developer portal configuration
4. `golden-path-templates/` — Backstage Software Templates

## Verification
- `terraform validate` passes
- Backstage template.yaml follows scaffolder spec
- ArgoCD manifests are valid CRDs
