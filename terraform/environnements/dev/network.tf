module "network" {
  source = "../../modules/network"

  vpc_tag = "vpc-dev"

  cluster_name = local.cluster_name
}