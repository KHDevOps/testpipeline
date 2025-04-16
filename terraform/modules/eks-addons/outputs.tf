output "oidc_provider_arn" {
  description = "ARN du provider OIDC pour le cluster EKS"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "ebs_csi_driver_role_arn" {
  description = "ARN du rôle IAM pour l'EBS CSI Driver"
  value       = aws_iam_role.ebs_csi_driver.arn
}
