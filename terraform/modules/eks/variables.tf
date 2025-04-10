variable "cluster_name" {
  type        = string
  description = "The name of the eks"
  default     = "eks-cluster"
}

variable "allowed_admin_cidrs" {
  description = "CIDR blocks for the admin"
  type        = list(string)
  default     = [] #Dev
}

variable "instance_type" {
  description = "Instance type for the Kubernetes cluster"
  type        = string
  default     = "t2.micro"
}

variable "subnet_ids" {
  description = "Id of the subnet"
  type        = list(string)
}
/*
variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "cluster_sg_id" {
  description = "Security group ID for the EKS cluster"
  type        = string
}

variable "eks_secrets_arn" {
  description = "EKS Secret ARN"
  type = string
}*/

variable "eks_cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role ARN for EKS nodes"
  type        = string
}

