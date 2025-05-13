variable "domain_name" {
  description = "Main domain name (e.g., leo-mendoza.com)"
  type        = string
}

variable "subdomains" {
  description = "List of subdomains to create"
  type        = list(string)
  default     = []
}

variable "load_balancer_dns_name" {
  description = "DNS name of the load balancer"
  type        = string
}

variable "load_balancer_zone_id" {
  description = "Zone ID of the load balancer"
  type        = string
}

variable "zone_id" {
  description = "Zone ID of the Route53 zone"
  type        = string
}