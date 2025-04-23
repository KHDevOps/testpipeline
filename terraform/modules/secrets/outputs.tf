output "admin_ips_secret_arn" {
  description = "Secret ARN for admin ips"
  value       = aws_secretsmanager_secret.admin_ips.arn
}