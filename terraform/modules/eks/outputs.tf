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

output "eks_node_ids" {
  description = "IDs des instances EC2 des nœuds EKS"
  value       = data.aws_instances.eks_nodes.ids
}