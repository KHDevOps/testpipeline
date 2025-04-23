module security {
    source = "../../modules/security"

    cluster_name = local.cluster_name
    vpc_id = module.network.vpc_id
    environment = local.environment
}