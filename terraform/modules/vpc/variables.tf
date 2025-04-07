variable "region" {
  type        = string
  description = "The region of the deployment"
  default     = "eu-north-1"
}

variable "vpc_tag" {
  type        = string
  description = "The tag of the vpc"
  default     = "vpc"
}

variable "subnet_tag" {
  type        = string
  description = "The tag of the subnet"
  default     = "nodes-subnet"
}