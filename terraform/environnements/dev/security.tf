module security {
    source = "../../modules/security"

    cluster_name = local.cluster_name
    vpc_id = module.network.vpc_id
    allowed_admin_cidrs = var.allowed_admin_cidrs
    environment = local.environment
}