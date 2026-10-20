# Runbook — internal-developer-platform-poc
> Last updated: 2026-08-29

## Quick Start
```bash
# Bring up the cluster and deploy ArgoCD
kind create cluster --name idp-platform
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=120s
```

## Run Tests / Demos
```bash
bash scripts/demo_self_service_flow.sh
```

## Failure Modes
| Symptom | Cause | Fix |
|---|---|---|
| Argo CD OutOfSync | Manual changes made via kubectl | Argo CD acts as source of truth; any ad-hoc kubectl changes will be overwritten or show as drift |


---

## Release Runbook

### Release Trigger
Tag push matching `v*.*.*` (e.g., `v0.1.0`).

### Automated Pipeline Stages
1. **Quality & Validation Gate:** Validates policy syntax, manifest schemas, and configuration integrity.
2. **Distribution Packaging:** Bundles clean production manifests into `internal-developer-platform-poc-<tag>.tar.gz` and calculates SHA256 checksums.
3. **Syft Source SBOM:** Generates `sbom.spdx.json` adhering to SPDX 2.3 standard.
4. **GitHub Release:** Publishes release assets and release notes.

### Verification
```bash
gh release view v0.1.0 --repo SumitDalavi/internal-developer-platform-poc
gh release download v0.1.0 --repo SumitDalavi/internal-developer-platform-poc --pattern "checksums.txt"
```

### Failure Modes & Remediation
- **Linter / Test Failure:** Inspect policy syntax, configurations, or module arguments locally before tagging.
- **Checksum Mismatch:** Ensure file was completely downloaded without network truncation.
