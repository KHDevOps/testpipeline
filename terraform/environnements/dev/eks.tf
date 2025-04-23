module "eks" {
  source = "../../modules/eks"

  cluster_name = local.cluster_name

  subnet_ids = module.network.private_subnet_ids

  cluster_sg_id = module.security.eks_cluster_sg_id
  node_sg_id = module.security.eks_nodes_sg_id

  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn

  

  depends_on = [
    module.security,
    module.iam.eks_cluster_policy_attachment
  ]
}
