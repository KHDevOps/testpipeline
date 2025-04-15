output "cluster_endpoint" {
  description = "API EKS endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "Cluster name"
  value       = aws_eks_cluster.main.name
}