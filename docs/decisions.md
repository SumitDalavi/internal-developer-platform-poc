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

## ADR-002: Progressive Credential Loading (PCL) Architecture
- **Context:** Production hardening required live backends (PostgreSQL, Redis, OpenAI, Anthropic), but removing mocks would break CI pipelines and create high developer onboarding friction.
- **Decision:** Implement Progressive Credential Loading. Keep in-memory and local mock heuristics as the default safe baseline, while wrapping external integrations in auto-promoting factory adapters triggered by environment variables.
- **Consequences:** 
  - *Pros:* 100% CI pass rate without requiring external secrets; zero setup friction for new contributors; progressive upgrade to production clusters.
  - *Cons:* Adds lightweight factory abstraction layers and runtime credential detection logic.
