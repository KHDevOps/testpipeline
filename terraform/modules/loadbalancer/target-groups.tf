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

resource "aws_lb_target_group_attachment" "ingress_http_nodes" {
  for_each = toset(var.eks_node_ids)
  
  target_group_arn = aws_lb_target_group.ingress_http_tg.arn
  target_id        = each.value
  port             = var.ingress_http_nodeport
}