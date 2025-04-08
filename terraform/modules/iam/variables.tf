variable "cluster_name" {
  type        = string
  description = "The name of the EKS"
  default     = "eks-cluster"
}

variable "account_id" {
  type        = string
  description = "Account ID"
}

variable "aws_region" {
  type        = string
  description = "Account Region"
}