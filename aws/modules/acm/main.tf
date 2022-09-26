#If you're keeping Route53 records in a different account, enable this and enter the credentials for that account.
provider "aws" {
  region  = "us-east-1"
  alias   = "edtech-nonprod"
  profile = "cd-edtech-nonprod"
  assume_role {
    role_arn = var.assume_role
  }
}

#Enable this and enter the credentials for your AWS account
provider "aws" {
  region  = "us-east-1"
  profile = "fouo-nonprod"
  alias   = "fouo-nonprod"
}
data "aws_route53_zone" "domain" {
  name     = var.main_domain_name
  provider = aws.edtech-nonprod
}

#Create A Wildcard certificate For CF
resource "aws_acm_certificate" "wildcard_cert" {
  domain_name       = var.wildcard_domain_name
  provider          = aws.fouo-nonprod
  validation_method = "DNS"

  tags = {
    Name        = "${var.app_name}-${var.env_name}-wildcard-acm"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }

  lifecycle {
    create_before_destroy = true
  }
}

#Attach the Wildcard certificate to Route53
resource "aws_route53_record" "wildcard_domain_record" {
  provider = aws.edtech-nonprod
  for_each = {
    for dvo in aws_acm_certificate.wildcard_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.zone_id
}

#Validate Wildcard certificate For CF
resource "aws_acm_certificate_validation" "wildcard_certificate_validation" {
  provider                = aws.fouo-nonprod
  certificate_arn         = aws_acm_certificate.wildcard_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.wildcard_domain_record : record.fqdn]
}
