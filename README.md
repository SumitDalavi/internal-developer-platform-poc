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

## 👨‍💻 Author

*Built to demonstrate Platform Engineering and Developer Self-Service.*
