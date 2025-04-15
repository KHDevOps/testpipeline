variable "aws_region" {
  description = "Region of the deployment"
  type        = string
  default     = "eu-west-3a"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_tag" {
  description = "Tag for the VPC"
  type        = string
  default     = "eks-vpc"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
/*
variable "bastion_instance_id" {
  description = "Instance Bastion Id"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet (jenkins)"
  type        = string
  default     = "10.0.3.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR block pour le sous-réseau public du bastion"
  type        = string
  default     = "10.0.103.0/24"
}*/