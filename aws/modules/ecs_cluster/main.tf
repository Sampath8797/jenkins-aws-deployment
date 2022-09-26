resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.app_name}-${var.env_name}-cluster"

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-cluster"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}