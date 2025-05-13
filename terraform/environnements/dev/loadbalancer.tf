module "loadbalancer" {
  source = "../../modules/loadbalancer"
  environment = local.environment
  public_subnet_ids = module.network.public_subnet_ids
  vpc_id = module.network.vpc_id
  load_balancer_sg_id = module.security.lb_sg_id
  eks_nodes_sg_id = module.security.eks_nodes_sg_id
  cluster_name = local.cluster_name
  domain_name = var.domain_name
  certificate_arn = data.aws_acm_certificate.wildcard.arn
}