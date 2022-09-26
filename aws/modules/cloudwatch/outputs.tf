output "app_logs" {
  value = aws_cloudwatch_log_group.logs.id
}