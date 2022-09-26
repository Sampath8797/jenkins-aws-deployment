output "rds_kms_key_arn" {
  value = aws_kms_key.rds_key.arn
}