module "eks" {
  source = "../../modules/eks"

  cluster_name = local.cluster_name

  #private_subnet_ids   = module.network.private_subnet_ids
  #public_subnet_ids    = module.network.public_subnet_ids
  #cluster_sg_id        = module.security.eks_cluster_sg_id
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
  #eks_secrets_arn = module.security.eks_secrets_arn
  subnet_ids = module.network.private_subnet_ids

  allowed_admin_cidrs = var.allowed_admin_cidrs
  /*
  depends_on = [
    module.iam.eks_cluster_policy_attachment,
    module.iam.eks_worker_node_policy_attachment,
    module.iam.eks_cni_policy_attachment,
    module.iam.eks_container_registry_policy_attachment
  ]*/
}
