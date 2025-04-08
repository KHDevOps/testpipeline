variable "region" {
  type        = string
  description = "The region of the deployment"
  default     = "eu-north-1"
}

variable "allowed_admin_cidrs" {
  description = "CDR list admins"
  type        = list(string)
  default     = []
}