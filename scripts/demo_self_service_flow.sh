#!/bin/bash
set -e

echo "================================================="
echo "🏗️  Running Internal Developer Platform Self-Service Demo"
echo "================================================="

echo "1. Developer selects 'Node.js Microservice' template in Backstage..."
echo "✅ Simulating Backstage scaffolder..."
# Pretend we templated the Golden Path manifest
cat <<EOF > /tmp/golden-path-request.yaml
apiVersion: platform.demo/v1alpha1
kind: GoldenPathService
metadata:
  name: demo-service
  namespace: demo-namespace
spec:
  language: "nodejs"
  database: "postgres"
  owner: "team-alpha"
EOF
echo "✅ Generated GoldenPathService CRD."

echo "2. IDP commits the CRD to the GitOps Repository..."
echo "✅ Committed to argocd-gitops/platform-apps/demo-service.yaml"

echo "3. ArgoCD synchronizes the state to Kubernetes..."
# Simulate kubectl apply
echo "✅ Applying CRD to cluster..."

echo "4. Golden Path Operator provisions the resources..."
echo "✅ Creating Namespace: demo-namespace"
echo "✅ Enforcing Kyverno Policies..."
echo "✅ Provisioning PostgreSQL via Crossplane/Terraform..."
echo "✅ Creating Deployment, Service, and NetworkPolicy..."

echo "5. Feedback to Developer..."
echo "✅ Service 'demo-service' is active!"
echo "✅ All self-service Golden Path flows executed successfully."
