output "zone_id" {
  description = "Route 53 zone ID"
  value       = data.aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "Name servers for the zone (useful for configuring the domain at the registrar)"
  value       = data.aws_route53_zone.main.name_servers
}

output "domain_name" {
  description = "Configured domain name"
  value       = var.domain_name
}