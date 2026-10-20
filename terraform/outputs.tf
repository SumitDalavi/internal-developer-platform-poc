output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = var.cluster_name
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "namespace" {
  description = "IDP namespace"
  value       = kubernetes_namespace.idp.metadata[0].name
}
