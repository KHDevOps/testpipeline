module "compute" {
  source = "../../modules/compute"

  bastion_sg_id = module.security.bastion_sg_id
  jenkins_sg_id = module.security.jenkins_sg_id

  public_subnet_bastion_id = module.network.public_subnet_bastion_id
  private_subnet_jenkins_id = module.network.private_subnet_jenkins_id

  public_key_ssh_path = var.public_key_ssh_path
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../../../ansible/inventory/terraform_inventory.tpl", {
    jenkins_ip = module.compute.jenkins_private_ip
    bastion_ip = module.compute.bastion_public_ip
  })
  filename = "${path.module}/../../../ansible/inventory/hosts.ini"
}