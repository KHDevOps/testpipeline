output "cluster_endpoint" {
  description = "API EKS endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "Cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_oidc_issuer_url" {
  description = "URL de l'émetteur OIDC du cluster EKS"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}