terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_secretsmanager_secret" "admin_ips" {
  name        = "${var.cluster_name}-admin-ips"
  description = "Admin IP address allowed to access EKS cluster"
  
  tags = {
    Name        = "${var.cluster_name}-admin-ips"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "admin_ips" {
  secret_id     = aws_secretsmanager_secret.admin_ips.id
  secret_string = jsonencode(var.admin_ips)
}