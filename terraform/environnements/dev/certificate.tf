data "aws_secretsmanager_secret" "domain_name" {
  arn = module.secrets.domain_name_secret_arn
  depends_on = [module.secrets]
}

data "aws_secretsmanager_secret_version" "domain_name" {
  secret_id = data.aws_secretsmanager_secret.domain_name.id
  depends_on = [module.secrets]
}

locals {
  domain_name = data.aws_secretsmanager_secret_version.domain_name.secret_string
}

data "aws_acm_certificate" "wildcard" {
  domain     = local.domain_name
  statuses   = ["ISSUED"]
  types      = ["AMAZON_ISSUED"]
  most_recent = true
}