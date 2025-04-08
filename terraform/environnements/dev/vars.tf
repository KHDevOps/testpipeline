data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  cluster_name = "eks-cluster-dev"

}