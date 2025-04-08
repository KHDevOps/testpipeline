module "eks" {
  source = "../../modules/eks"

  cluster_name = local.cluster_name

  private_subnet_ids   = module.network.private_subnet_ids
  public_subnet_ids    = module.network.public_subnet_ids
  cluster_sg_id        = module.network.eks_cluster_sg_id
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn

  account_id = data.aws_caller_identity.current.account_id

  allowed_admin_cidrs = var.allowed_admin_cidrs

  depends_on = [
    module.iam.eks_cluster_policy_attachment,
    module.iam.eks_worker_node_policy_attachment,
    module.iam.eks_cni_policy_attachment,
    module.iam.eks_container_registry_policy_attachment
  ]
}
