terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_lb" "monitoring_lb" {
  name               = "${var.environment}-monitoring-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.load_balancer_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.environment == "prod" ? true : false

  tags = {
    Name        = "${var.environment}-monitoring-alb"
    Environment = var.environment
    Purpose     = "Access to monitoring and CI/CD UIs"
  }
}

resource "null_resource" "cleanup_before_destroy" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl get svc -A | grep -i LoadBalancer | awk '{print $1, $2}' | xargs -I {} sh -c 'kubectl delete svc {} -n {}' && sleep 30"
  }

  depends_on = [aws_lb.monitoring_lb]
}