variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
    type = string
    description = "Id of the VPC"
}
/*
variable "flow_log_role_arn" {
  description = "ARN VPC Flow Logs"
  type        = string
}

variable "flow_log_destination_arn" {
  description = "ARN VPC Flow Logs (CloudWatch Log Group)"
  type        = string
}*/

variable "account_id" {
  description = "Account ID"
  type        = string
}

variable "my_ip" {
    description = "Personal Ip"
    type = string
}