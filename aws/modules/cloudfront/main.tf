#If you're keeping Route53 records in a different account, enable this and enter the credentials for that account.
provider "aws" {
  region  = "us-east-1"
  alias   = "edtech-nonprod"
  profile = "cd-edtech-nonprod"
  assume_role {
    role_arn = var.assume_role
  }
}

data "aws_route53_zone" "domain" {
  name     = var.main_domain_name
  provider = aws.edtech-nonprod
}

resource "aws_cloudfront_origin_access_identity" "cdn_access_identity" {
  comment = "origin access identity for cloudfront"
}
resource "aws_cloudfront_distribution" "main_cdn" {
  origin {
    domain_name = var.s3_static
    origin_id   = "${var.app_name}-${var.env_name}-static-contents"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cdn_access_identity.cloudfront_access_identity_path
    }
  }

  default_root_object = "index.html"
  enabled             = true
  lifecycle {
    prevent_destroy = false
  }

  aliases = [var.frontend_domain_name, var.alb_domain_name]

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.app_name}-${var.env_name}-static-contents"
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false
      headers      = []

      cookies {
        forward = "all"
      }
    }
  }

  origin {
    domain_name = var.alb_domain_name
    origin_id   = "${var.app_name}-${var.env_name}-alb"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 60
      origin_keepalive_timeout = 40
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  ordered_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    compress               = false
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    path_pattern           = "/"
    smooth_streaming       = false
    target_origin_id       = "${var.app_name}-${var.env_name}-alb"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["Authorization", "Host"]

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.nv_cf_certificate
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  logging_config {
    include_cookies = true
    bucket          = "${var.cf_logs_s3_bucket}.s3.amazonaws.com"
    prefix          = "cloudfront"
  }

  tags = {
    Name        = "${var.app_name}-${var.env_name}-cdn"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

resource "aws_route53_record" "cdn_domain_record" {
  provider = aws.edtech-nonprod
  zone_id  = data.aws_route53_zone.domain.zone_id

  allow_overwrite = true
  name            = var.frontend_domain_name
  type            = "A"
  alias {
    name                   = aws_cloudfront_distribution.main_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.main_cdn.hosted_zone_id
    evaluate_target_health = true
  }
}
