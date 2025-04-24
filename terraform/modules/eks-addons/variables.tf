variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "URL de l'émetteur OIDC du cluster EKS"
  type        = string
}

variable "account_id" {
  description = "ID du compte AWS"
  type        = string
}

variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3"
}