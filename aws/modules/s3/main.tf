resource "aws_s3_bucket" "cf_logs" {
  bucket = "${var.app_name}-${var.env_name}-cf-logs"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "${var.app_name}-${var.env_name}-cf-logs"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

resource "aws_s3_bucket" "s3_frontend" {
  bucket = "${var.app_name}-${var.env_name}-static-contents"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "${var.app_name}-${var.env_name}-static-contents"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}
