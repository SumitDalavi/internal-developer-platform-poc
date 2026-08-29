# Decisions

## ADR-001: ArgoCD over GitHub Actions for Deployment
**Date:** 2026-08-29  
**Status:** Accepted

**Context:**  
We need a standardized CD mechanism for the Golden Path templates.

**Decision:**  
We chose ArgoCD (GitOps pattern) rather than CI-push deployments.

**Consequences:**  
- ✅ Prevents config drift and strictly enforces desired state.
- ✅ Backstage only needs to commit to a Git repo, abstracting away Kubernetes auth.
- ⚠️ Requires running a GitOps controller in the cluster.
