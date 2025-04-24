resource "aws_lb_target_group" "ingress_http_tg" {
  name     = "${var.environment}-ingress-http-tg"
  port     = var.ingress_http_nodeport 
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/healthz"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name        = "${var.environment}-ingress-http-tg"
    Environment = var.environment
  }
}

# Instead of using for_each with unknown values, create a null_resource 
# that will be triggered after EKS nodes are created
resource "null_resource" "register_targets" {
  # This will force this resource to be created after the EKS nodes are available
  triggers = {
    target_group_arn = aws_lb_target_group.ingress_http_tg.arn
    # Add a timestamp to ensure this runs on every apply
    timestamp = timestamp()
  }

  # Use local-exec to register targets using AWS CLI
  provisioner "local-exec" {
    command = <<-EOT
      # Get the node IDs from EKS cluster
      NODE_IDS=$(aws ec2 describe-instances --filters "Name=tag:kubernetes.io/cluster/${var.cluster_name},Values=owned" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" --output text)
      
      # Register each node with the target group
      for NODE_ID in $NODE_IDS; do
        aws elbv2 register-targets --target-group-arn ${aws_lb_target_group.ingress_http_tg.arn} --targets Id=$NODE_ID,Port=${var.ingress_http_nodeport}
      done
    EOT
  }

  depends_on = [aws_lb_target_group.ingress_http_tg]
}