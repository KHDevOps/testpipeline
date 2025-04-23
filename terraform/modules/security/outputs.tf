output "eks_cluster_sg_id" {
  description = "Security group ID for the EKS cluster"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_sg_id" {
  description = "Security group ID for the EKS nodes"
  value       = aws_security_group.eks_nodes.id
}

output "lb_sg_id" {
  description = "Load balancer Security group ID"
  value       = aws_security_group.lb_sg.id
}

output "ssh_key_secret_arn" {
  description = "ARN du secret pour la clé SSH"
  value       = aws_secretsmanager_secret.ssh_key.arn
}

output "admin_ip_secret_arn" {
  description = "ARN du secret pour l'IP admin"
  value       = aws_secretsmanager_secret.admin_ip.arn
}