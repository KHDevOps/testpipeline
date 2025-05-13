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

data "aws_secretsmanager_secret" "admin_ips" {
  arn = var.admin_ips_secret_arn
}

data "aws_secretsmanager_secret_version" "admin_ips" {
  secret_id = data.aws_secretsmanager_secret.admin_ips.id
}

locals {
  admin_ips_cidr = jsondecode(data.aws_secretsmanager_secret_version.admin_ips.secret_string)
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
    public_access_cidrs     = local.admin_ips_cidr
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

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${aws_eks_cluster.main.name} \
      --b64-cluster-ca ${aws_eks_cluster.main.certificate_authority[0].data} \
      --apiserver-endpoint ${aws_eks_cluster.main.endpoint}
    EOF
  )
  
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnet_ids

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  capacity_type = "ON_DEMAND"

  tags = {
  "k8s.io/cluster-autoscaler/enabled"               = "true"
  "k8s.io/cluster-autoscaler/${var.cluster_name}"   = "owned"
  }
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [aws_eks_cluster.main]
  
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region eu-west-3 --name eks-cluster-dev"
  }
}

data "aws_instances" "eks_nodes" {
  depends_on = [aws_eks_node_group.main]
  
  filter {
    name   = "tag:kubernetes.io/cluster/${var.cluster_name}"
    values = ["owned"]
  }
  
  filter {
    name   = "tag:eks:nodegroup-name"
    values = ["${var.cluster_name}-ng"]
  }
  
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}