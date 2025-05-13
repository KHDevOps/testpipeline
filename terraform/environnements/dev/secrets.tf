module "secrets" {
  source = "../../modules/secrets"

  cluster_name = local.cluster_name
  environment  = local.environment
  admin_ips    = var.admin_ips
  domain_name  = var.domain_name
}