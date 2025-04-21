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

variable "eks_node_ids" {
  description = "Liste des IDs des nœuds EKS"
  type        = list(string)
}

variable "eks_nodes_sg_id" {
  description = "ID du Security Group des nœuds EKS"
  type        = string
}

variable "ingress_http_nodeport" {
  description = "NodePort HTTP de l'Ingress Controller"
  type        = number
  default     = 32091
}

variable "ingress_https_nodeport" {
  description = "NodePort HTTPS de l'Ingress Controller"
  type        = number
  default     = 31672
}