# Internal Developer Platform (IDP) PoC 🚀

A comprehensive Platform Engineering Proof of Concept demonstrating a modern **Internal Developer Platform (IDP)**.

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

## 🛠️ Tech Stack

- **Infrastructure**: Terraform, AWS (EKS, VPC)
- **Delivery**: ArgoCD, Kubernetes, Helm
- **Portal**: Backstage (React/Node.js)

## 👨‍💻 Author

*Created as a technical showcase for Platform Engineering and DevOps.*
