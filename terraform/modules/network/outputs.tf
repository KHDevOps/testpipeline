output "private_subnet_ids" {
  description = "Private subnets IDS"
  value       = aws_subnet.private[*].id
}

output "vpc_id" {
  description = "Id of the Vpc"
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "Public subnets IDS"
  value = aws_subnet.public[*].id
}