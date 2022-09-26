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

resource "aws_alb" "alb" {
  name                       = "${var.app_name}-${var.env_name}-alb"
  subnets                    = [var.public_subnet_1, var.public_subnet_2]
  security_groups            = [var.alb_sg]
  idle_timeout               = 60
  enable_deletion_protection = true

  tags = {
    Name        = "${var.app_name}-${var.env_name}-alb"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "${var.app_name}-${var.env_name}-backend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 30
    path                = "/healthCheck"
  }

  tags = {
    Name        = "${var.app_name}-${var.env_name}-backend-tg"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

resource "aws_lb_listener_rule" "backend_redirection" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    host_header {
      values = [var.alb_domain_name]
    }
  }
}

resource "aws_route53_record" "alb_domain_record" {
  provider = aws.edtech-nonprod
  zone_id  = data.aws_route53_zone.domain.zone_id

  allow_overwrite = true
  name            = var.alb_domain_name
  type            = "A"
  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}