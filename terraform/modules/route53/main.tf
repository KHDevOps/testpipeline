terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_route53_record" "subdomains" {
  for_each = toset(var.subdomains)
  
  zone_id = var.zone_id
  name    = "${each.value}.${var.domain_name}"
  type    = "A"
  
  alias {
    name                   = var.load_balancer_dns_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}