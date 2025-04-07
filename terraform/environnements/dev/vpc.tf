module "vpc" {
  source = "../../modules/vpc"

  vpc_tag = "vpc-dev"

  subnet_az1_tag = "eks-subnet-1-dev"

  subnet_az2_tag = "eks-subnet-2-dev"
}