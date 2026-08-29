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
