module security {
    source = "../../modules/security"

    cluster_name = local.cluster_name
    vpc_id = module.network.vpc_id
    account_id = data.aws_caller_identity.current.account_id

    flow_log_role_arn        = module.iam.flow_log_role_arn
    flow_log_destination_arn = module.iam.flow_log_group_arn

}