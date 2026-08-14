# Internal Developer Platform (IDP) PoC 🏗️

> A self-service Internal Developer Platform demonstrating automated provisioning, GitOps delivery, and policy-as-code.

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

---

*Built with a focus on production-grade patterns, not toy demos.*