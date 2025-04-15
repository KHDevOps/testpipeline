output "eks_cluster_role_arn" {
  description = "ARN rôle IAM for the EKS cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_cluster_policy_attachment" {
  description = "Policy attachment for the EKS cluster"
  value       = aws_iam_role_policy_attachment.eks_cluster_policy
}

output "eks_node_role_arn" {
  description = "IAM role ARN for EKS nodes"
  value       = aws_iam_role.eks_node_role.arn
}

output "eks_worker_node_policy_attachment" {
  description = "Policy attachment for EKS worker nodes"
  value       = aws_iam_role_policy_attachment.eks_worker_node_policy
}

output "eks_cni_policy_attachment" {
  description = "Policy attachment for EKS CNI"
  value       = aws_iam_role_policy_attachment.eks_cni_policy
}

output "eks_container_registry_policy_attachment" {
  description = "Policy attachment for container registry access"
  value       = aws_iam_role_policy_attachment.eks_container_registry_policy
}

output "flow_log_role_arn" {
  description = "Flow Log Role Arn"
  value       = aws_iam_role.flow_log_role.arn
}

output "flow_log_group_arn" {
  description = "Flow Log Group Arn"
  value       = aws_cloudwatch_log_group.flow_log_group.arn
}