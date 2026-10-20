> **NOTE:** This repository is an archival lab or partial prototype. It is not actively maintained and should not be used as a reference for production-grade deployments or performance benchmarks.

# Internal Developer Platform (IDP) PoC 🏗️

[![CI Pipeline](https://github.com/SumitDalavi/internal-developer-platform-poc/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/SumitDalavi/internal-developer-platform-poc/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/SumitDalavi/internal-developer-platform-poc?color=0969da&label=release&logo=github)](https://github.com/SumitDalavi/internal-developer-platform-poc/releases)
[![Release Workflow](https://github.com/SumitDalavi/internal-developer-platform-poc/actions/workflows/release.yml/badge.svg)](https://github.com/SumitDalavi/internal-developer-platform-poc/actions/workflows/release.yml)
[![Terraform](https://img.shields.io/badge/Terraform-1.6+-844FBA?logo=terraform&logoColor=white)](https://www.terraform.io)
[![SBOM](https://img.shields.io/badge/SBOM-SPDX%202.3-blueviolet?logo=spdx)](https://github.com/SumitDalavi/internal-developer-platform-poc/releases/tag/v0.2.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

> **Maturity:** Lab / Reference Implementation
> _A self-service Internal Developer Platform demonstrating automated provisioning, GitOps delivery, and policy-as-code._

## The Problem

Developers waste hours waiting on operations teams to provision repositories, configure CI/CD pipelines, set up Kubernetes namespaces, and provision cloud resources. This ticketing bottleneck slows down feature delivery and leads to inconsistent infrastructure configurations.

## The Solution

This PoC demonstrates an Internal Developer Platform that ties together **Backstage** (for self-service), **GitHub Actions** (for CI), **ArgoCD** (for GitOps delivery), **Terraform** (for infrastructure provisioning), and **Kyverno** (for policy enforcement). 

Instead of opening Jira tickets for a new database, repository, or namespace, developers choose a "Golden Path" template in Backstage, and the platform handles the rest securely and automatically.

## Why This Over the Obvious Alternative

Many teams just use Jenkins pipelines and call it "DevOps." This project demonstrates true **Platform Engineering**. By providing a self-service portal (Backstage) backed by a declarative GitOps engine (ArgoCD) and automated policy enforcement (Kyverno), we shift operations left without burdening developers with infrastructure complexity.

## 🛠️ Tech Stack

- **Developer Portal**: Backstage (Spotify)
- **CI/CD**: GitHub Actions, ArgoCD (GitOps)
- **Infrastructure as Code**: Terraform
- **Kubernetes Engine**: Amazon EKS (Mocked)
- **Policy Engine**: Kyverno

## Decision Log

| Decision | Rationale |
|----------|-----------|
| ArgoCD over GitHub Actions for CD | ArgoCD pulls state continuously from Git (true GitOps) rather than pushing from CI, ensuring the cluster always matches the desired state and preventing configuration drift. |
| Backstage over Custom UI | Backstage is the CNCF standard for developer portals; utilizing its scaffolding engine provides immediate self-service capabilities. |
| App of Apps Pattern | Centralizes the management of multiple ArgoCD applications, allowing the platform team to bootstrap an entire cluster from a single root application. |

## 📁 Project Structure

```
├── argocd-gitops/
│   ├── app-of-apps.yaml       # Root ArgoCD application
│   └── platform-apps/         # Child applications (Prometheus, etc)
├── backstage-portal/
│   ├── app-config.yaml        # Backstage configuration
│   └── catalog-info.yaml      # Component registry
├── templates/
│   ├── backstage-scaffolder/  # Backstage Golden Path templates
│   ├── github-actions/        # Standardized CI pipelines
│   └── kyverno/               # K8s policy-as-code definitions
├── terraform-eks/
│   ├── main.tf                # EKS cluster provisioning
│   └── variables.tf
├── docs/ARCHITECTURE.md
└── README.md
```

## 📋 Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | >= 1.28 | Kubernetes CLI |
| [kind](https://kind.sigs.k8s.io/) or [minikube](https://minikube.sigs.k8s.io/) | Latest | Local K8s cluster |
| [Terraform](https://www.terraform.io/) | >= 1.5 | Infrastructure provisioning |
| [Argo CD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/) | >= 2.9 | GitOps CLI |
| [Docker](https://www.docker.com/) | >= 24.x | Container runtime |
| [Node.js](https://nodejs.org/) | >= 18.x | Backstage portal |

## 🚀 Step-by-Step Setup

### Option A: Local Cluster (kind)

```bash
# 1. Clone the repository
git clone https://github.com/SumitDalavi/internal-developer-platform-poc.git
cd internal-developer-platform-poc

# 2. Create a local cluster
kind create cluster --name idp-platform

# 3. Provision infrastructure with Terraform
cd terraform/
terraform init
terraform plan
terraform apply -auto-approve
cd ..

# 4. Install Argo CD for GitOps
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=120s

# 5. Apply Argo CD project and root application
kubectl apply -f argocd-gitops/app-project.yaml
kubectl apply -f argocd-gitops/root-application.yaml

# 6. Apply Kyverno policies
kubectl apply -f templates/kyverno/require-labels.yaml

# 7. Apply CI pipeline template
# The GitHub Actions template is at templates/github-actions/ci-pipeline.yaml
```

### Option B: Existing Cloud Cluster

```bash
kubectl cluster-info
# Follow steps 3-7 from Option A
```

## 🧪 Usage & Demo â€” Golden Path Templates

### Step 1: Scaffold a new microservice from the Golden Path
```bash
# Review the template
cat golden-path-templates/nodejs-microservice/template.yaml

# The template generates:
# - Dockerfile
# - K8s deployment manifests
# - catalog-info.yaml (Backstage integration)
# - package.json with standard scripts
```

### Step 2: Deploy via Argo CD
```bash
# List all managed applications
argocd app list

# Sync the root application
argocd app sync root-app
```

### Step 3: Access the Backstage Portal
```bash
# Configure Backstage
cat backstage-portal/app-config.yaml

# For full Backstage setup, follow the official docs:
# https://backstage.io/docs/getting-started/
```

## ✅ Verification

| Check | Command | Expected |
|-------|---------|----------|
| Cluster ready | `kubectl get nodes` | Nodes in Ready state |
| Terraform applied | `terraform output` | Resource outputs |
| Argo CD running | `kubectl get pods -n argocd` | All pods running |
| Policies active | `kubectl get clusterpolicies` | require-labels policy |
| Templates available | `ls golden-path-templates/` | Template directories |

```bash
# Cleanup
kind delete cluster --name idp-platform
```

## 👨‍💻 Author

**Sumit Dalavi** — Senior DevSecOps / Platform Engineer
[GitHub](https://github.com/SumitDalavi) | [LinkedIn](https://in.linkedin.com/in/sumit-dalavi-762838129)

## 🚀 Progressive Credential Loading & Execution Tiers

This project implements **Progressive Credential Loading (PCL)**, allowing it to run immediately out-of-the-box without external dependencies while seamlessly upgrading as credentials are provided.

### Tier 1: Zero-Config Mock Mode (Default)
Ideal for CI, testing, and rapid local evaluation.
- **Execution:** Run with default configuration (`cp .env.example .env`). Zero API keys, databases, or cloud credentials required.
- **Fallback Behavior:** In-memory caches, deterministic offline heuristics, mock vector embeddings, and local mock storage are automatically used.
- **Health Verification:** Endpoints report `{"mode": "mock"}` for unconfigured dependencies.

### Tier 2: Local Development with Live Services
Connect specific external services while keeping others mocked.
- **Execution:** Provide credentials in `.env` for the services you want active (e.g., `GITHUB_TOKEN, BACKSTAGE_PORT`).
- **Progressive Upgrade:** The runtime inspects environment variables on boot and dynamically promotes only configured modules to live mode.
- **Safe Fallback:** Any missing credentials automatically remain on mock fallbacks with no crashes or missing service errors.

### Tier 3: Production Hardened
Enterprise deployment with production-grade backends, security scans, and container distributions.
- **Release Distribution:** Download standalone release bundle and verified checksums:
  ```bash
  gh release download v0.2.0 --repo SumitDalavi/internal-developer-platform-poc
  ```
- **Integrity & Security:** Checksums and SPDX SBOM (`sbom.spdx.json`) available on [GitHub Releases](https://github.com/SumitDalavi/internal-developer-platform-poc/releases).

## 📚 Documentation

- [Architecture](docs/ARCHITECTURE.md) — System diagram and component details
- [Runbook](docs/runbook.md) — Setup, commands, and expected outputs
- [Decisions](docs/decisions.md) — ADRs for Platform Engineering choices
- [Changelog](docs/changelog.md) — Change history

## Mock Boundaries (Honest Scope)

| What | Status | Details |
|---|---|---|
| Kubernetes Cluster | **Real** | Standard `kind` cluster running Argo CD. |
| Backstage Portal | **Simulated** | E2E script mimics Backstage's Scaffolder by generating templates via bash. |
| Golden Path CLI | **Real** | Integrated flow simulates calling the Golden Path operator/CLI. |

## 🔗 Related Projects

- [`k8s-golden-path-provisioner`](../k8s-golden-path-provisioner/) — The backend operator that executes the templates managed by this IDP.

## 📖 Overview

This repository demonstrates the convergence of three major Platform Engineering pillars:
1. **Developer Self-Service Portal** (Backstage)
2. **GitOps Delivery** (ArgoCD)
3. **Infrastructure as Code** (Terraform targeting AWS EKS)

It proves the ability to abstract away infrastructure complexity by providing developers with "Golden Paths"—standardized templates that scaffold microservices pre-wired for immediate Kubernetes deployment.

## 🏛️ Repository Architecture

- `/terraform`: AWS EKS cluster provisioning and ArgoCD Helm bootstrapping.
- `/argocd-gitops`: The GitOps state, utilizing the "App of Apps" pattern to manage cluster workloads declaratively.
- `/backstage-portal`: Configuration for the Backstage IDP.
- `/golden-path-templates`: Backstage Software Templates (`template.yaml`). When executed, these templates generate a repository with a Dockerfile, CI/CD, and Kubernetes manifests, then register the new service in the Backstage Software Catalog.

## 🌟 The "Golden Path" Workflow

1. A developer opens the **Backstage Portal**.
2. They click "Create" and select the **Node.js Microservice** template.
3. They input a service name (e.g., `payment-service`).
4. Backstage executes the `fetch:template` and `publish:github` actions:
   - A new GitHub repo `payment-service` is created.
   - The skeleton code (Express server, Dockerfile, k8s `Deployment` and `Service`) is pushed.
   - A `catalog-info.yaml` is added, registering the service in Backstage.
5. **ArgoCD** detects the new manifests (via the GitOps pattern) and automatically deploys `payment-service` to the EKS cluster.

---

## Release & Security Verification

This repository is published as an immutable release catalog under the portfolio release standard:

- **Release Artifacts:** Authenticated distribution bundle (`internal-developer-platform-poc-v0.1.0.tar.gz`) containing production policies, modules, and manifests.
- **Cryptographic Integrity:** SHA-256 integrity hash provided in `checksums.txt`.
- **Software Bill of Materials (SBOM):** Fully compliant SPDX JSON SBOM (`sbom.spdx.json`) generated by Anchore Syft.

### Verification Commands
```bash
# 1. View Release Metadata
gh release view v0.1.0 --repo SumitDalavi/internal-developer-platform-poc

# 2. Download Release Assets & Verify SHA256 Checksum
gh release download v0.1.0 --repo SumitDalavi/internal-developer-platform-poc --pattern "*.tar.gz" --pattern "checksums.txt"
sha256sum -c checksums.txt

# 3. Inspect SPDX SBOM
gh release download v0.1.0 --repo SumitDalavi/internal-developer-platform-poc --pattern "sbom.spdx.json"
cat sbom.spdx.json | jq .spdxVersion
```
