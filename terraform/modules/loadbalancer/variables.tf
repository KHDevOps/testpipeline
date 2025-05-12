variable "environment" {
    type = string
    description = "Environnement string"
}

variable "public_subnet_ids" {
  description = "IDS list of public subnets"
  type        = list(string)
}

variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "load_balancer_sg_id" {
    description = "Load Balancer Security Group ID"
    type = string
}

variable "cluster_name" {
  type        = string
  description = "The name of the eks"
  default     = "eks-cluster"
}

variable "eks_nodes_sg_id" {
  description = "ID du Security Group des nœuds EKS"
  type        = string
}

variable "ingress_http_nodeport" {
  description = "NodePort HTTP de l'Ingress Controller"
  type        = number
  default     = 31142
}

variable "ingress_https_nodeport" {
  description = "NodePort HTTPS de l'Ingress Controller"
  type        = number
  default     = 31080
}

variable "domain_name" {
  description = "Domain name"
  type = string
}

variable "certificate_arn" {
  description = "ACM certificat ARN for HTTPS listeners"
  type        = string
  default     = ""
}