resource "aws_secretsmanager_secret" "credentials" {
  name = "${var.app_name}-${var.env_name}-secret-manager"

  tags = {
    Name        = "${var.app_name}-${var.env_name}-secret-manager"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}
