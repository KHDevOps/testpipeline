module "network" {
  source = "../../modules/network"

  vpc_tag = "vpc-dev"

  cluster_name = local.cluster_name

  bastion_instance_id = module.compute.bastion_instance_id
}