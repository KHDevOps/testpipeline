output "private_subnet_ids" {
  description = "Private subnets list ids"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "Public subnets list ids"
  value       = aws_subnet.public[*].id
}

output "vpc_id" {
  description = "Id of the Vpc"
  value = aws_vpc.vpc.id
}