module "compute" {
  source = "../../modules/compute"

  bastion_sg_id = module.security.bastion_sg_id
  jenkins_sg_id = module.security.jenkins_sg_id

  public_subnet_bastion_id = module.network.public_subnet_bastion_id
  private_subnet_jenkins_id = module.network.private_subnet_jenkins_id

  public_key_ssh_path = var.public_key_ssh_path
}
