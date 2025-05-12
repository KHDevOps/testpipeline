module "acm" {
  source = "../../modules/acm"
  
  domain_name = var.domain_name
  zone_id     = module.route53.zone_id
  
  depends_on = [
    module.route53
  ]
}