module "route53" {
  source = "../../modules/route53"
  
  zone_id = module.dns_zone.zone_id
  domain_name = var.domain_name
  subdomains = [
    "prometheus",
    "grafana",
    "alertmanager", 
    "jenkins",
    "argocd"
  ]
  
  load_balancer_dns_name = module.loadbalancer.lb_dns_name
  load_balancer_zone_id  = module.loadbalancer.lb_zone_id

  depends_on = [module.loadbalancer]
}