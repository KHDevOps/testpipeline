module "network" {
  source = "../../modules/network"

  vpc_tag = "vpc-dev"

  cluster_name = local.cluster_name

  flow_log_role_arn        = module.iam.flow_log_role_arn
  flow_log_destination_arn = module.iam.flow_log_group_arn
}