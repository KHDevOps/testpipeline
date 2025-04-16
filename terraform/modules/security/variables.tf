variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
    type = string
    description = "Id of the VPC"
}

variable "allowed_admin_cidrs" {
  description = "List of CIDR blocks that are allowed to access the EKS API server"
  type        = list(string)
  default     = []
}