module "eks_addons" {
  source = "../../modules/eks-addons"
  
  cluster_name           = module.eks.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  account_id             = data.aws_caller_identity.current.account_id
  aws_region             = data.aws_region.current.name
  
  depends_on = [module.eks]
}