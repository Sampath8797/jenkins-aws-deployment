resource "aws_ecr_repository" "app_ecr" {
  name = "${var.app_name}-${var.env_name}-ecr"

  tags = {
    Name        = "${var.app_name}-${var.env_name}-ecr"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}
