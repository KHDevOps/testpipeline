output "private_subnet_ids" {
  description = "Private subnets list ids"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "Public subnets list ids"
  value       = aws_subnet.public[*].id
}

output "eks_cluster_sg_id" {
  description = "Group security id for cluster Kubernetes"
  value       = aws_security_group.eks_cluster.id
}