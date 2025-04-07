variable "vpc_tag" {
  type        = string
  description = "The tag of the vpc"
  default     = "vpc"
}

variable "subnet_az1_tag" {
  type        = string
  description = "The tag of the subnet az1"
  default     = "eks-subnet-1"
}

variable "subnet_az2_tag" {
  type        = string
  description = "The tag of the subnet az2"
  default     = "eks-subnet-2"
}

variable "region_az1" {
    type = string
    description = "The region of the subnet az1"
    default = "eu-north-1a"
}

variable "region_az2" {
    type = string
    description = "The region of the subnet az1"
    default = "eu-north-1b"
}