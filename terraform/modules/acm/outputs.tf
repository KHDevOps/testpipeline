output "certificate_arn" {
  description = "ACM Certificat ARN"
  value       = aws_acm_certificate.cert.arn
}