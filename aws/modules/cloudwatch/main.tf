resource "aws_cloudwatch_log_group" "logs" {
  name              = "${var.app_name}-${var.env_name}-logs"
  retention_in_days = 14

  tags = {
    Name        = "${var.app_name}-${var.env_name}-logs"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}
