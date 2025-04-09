terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#checkov:skip=CKV_AWS_39:Public endpoint permitted in dev environment
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = "1.28"

  vpc_config {
    subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)
    security_group_ids      = [var.cluster_sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.allowed_admin_cidrs
  }

  encryption_config {
    provider {
      key_arn = var.eks_secrets_arn
    }
    resources = ["secrets"]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnet_ids

  instance_types = [var.instance_type]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  disk_size = 20
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [aws_eks_cluster.main]
  
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region eu-north-1 --name eks-cluster-dev"
  }
}