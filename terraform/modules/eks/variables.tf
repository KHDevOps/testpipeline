variable "cluster_name" {
  type        = string
  description = "The name of the eks"
  default     = "eks-cluster"
}

variable "instance_type" {
  description = "Instance type for the Kubernetes cluster"
  type        = string
  default     = "t3.medium"
}

variable "subnet_ids" {
  description = "Id of the subnet"
  type        = list(string)
}

variable "cluster_sg_id" {
  description = "Security group ID for the EKS cluster"
  type        = string
}

variable "node_sg_id" {
  description = "Security group ID for the EKS nodes"
  type        = string
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role ARN for EKS nodes"
  type        = string
}

variable "admin_ips_secret_arn" {
  description = "ARN du secret contenant les IPs admin"
  type        = string
}