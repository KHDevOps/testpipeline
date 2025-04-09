output "eks_cluster_sg_id" {
  description = "Group security id for cluster Kubernetes"
  value       = aws_security_group.eks_cluster.id
}

output "eks_secrets_arn" {
    description = "EKS secret ARN"
    value = aws_kms_key.eks_secrets.arn
}