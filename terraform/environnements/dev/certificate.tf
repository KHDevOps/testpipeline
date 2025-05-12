data "aws_acm_certificate" "wildcard" {
  domain     = "leo-mendoza.com"
  statuses   = ["ISSUED"]
  types      = ["AMAZON_ISSUED"]
  most_recent = true
}