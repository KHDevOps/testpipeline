/*output "eks_cluster_sg_id" {
  description = "Group security id for cluster Kubernetes"
  value       = aws_security_group.eks_cluster.id
}

output "eks_secrets_arn" {
    description = "EKS secret ARN"
    value = aws_kms_key.eks_secrets.arn
}

output "jenkins_sg_id" {
    description = "Jenkins security group ID"
    value = aws_security_group.jenkins_sg.id
}

output "bastion_sg_id" {
    description = "Bastion security group ID"
    value = aws_security_group.bastion_sg.id
}*/