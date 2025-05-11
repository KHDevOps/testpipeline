resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.monitoring_lb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.monitoring_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress_http_tg.arn
  }
}

resource "aws_lb_listener_rule" "prometheus" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress_http_tg.arn
  }

  condition {
    host_header {
      values = ["prometheus.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "grafana" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress_http_tg.arn
  }

  condition {
    host_header {
      values = ["grafana.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "alertmanager" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress_http_tg.arn
  }

  condition {
    host_header {
      values = ["alertmanager.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "jenkins" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 40

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress_http_tg.arn
  }

  condition {
    host_header {
      values = ["jenkins.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "argocd" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress_http_tg.arn
  }

  condition {
    host_header {
      values = ["argocd.${var.domain_name}"]
    }
  }
}