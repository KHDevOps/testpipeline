terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_secretsmanager_secret" "admin_ips" {
  name        = "${var.cluster_name}-admin-ips-${random_id.suffix.hex}"
  description = "Admin IP address allowed to access EKS cluster"
  force_overwrite_replica_secret = true
  recovery_window_in_days = 0
  
  tags = {
    Name        = "${var.cluster_name}-admin-ips"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "admin_ips" {
  secret_id     = aws_secretsmanager_secret.admin_ips.id
  secret_string = jsonencode(var.admin_ips)
}

resource "aws_secretsmanager_secret" "domain_name" {
  name        = "${var.cluster_name}-domain-name-${random_id.suffix.hex}"
  description = "Domain name used for the platform"
  force_overwrite_replica_secret = true
  recovery_window_in_days = 0
  
  tags = {
    Name        = "${var.cluster_name}-domain-name"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "domain_name" {
  secret_id     = aws_secretsmanager_secret.domain_name.id
  secret_string = var.domain_name
}