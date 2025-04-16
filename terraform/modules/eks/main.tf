terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.main.version}/amazon-linux-2/recommended/image_id"
}

#checkov:skip=CKV_AWS_39:Public endpoint permitted in dev environment
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = "1.28"

  vpc_config {
    #subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)
    subnet_ids = var.subnet_ids
    security_group_ids      = [var.cluster_sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.allowed_admin_cidrs
  }
  /*
  encryption_config {
    provider {
      key_arn = var.eks_secrets_arn
    }
    resources = ["secrets"]
  }

  enabled_cluster_log_types = ["api"]*/
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "${var.cluster_name}-node-"
  image_id      = data.aws_ssm_parameter.eks_ami.value
  instance_type = var.instance_type
  
  vpc_security_group_ids = [var.node_sg_id] 
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnet_ids

  instance_types = [var.instance_type]


  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  disk_size = 8
  capacity_type = "ON_DEMAND"
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [aws_eks_cluster.main]
  
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region eu-west-3 --name eks-cluster-dev"
  }
}