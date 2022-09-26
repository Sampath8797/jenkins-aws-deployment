output "cf_logs_s3_bucket" {
  value = aws_s3_bucket.cf_logs
}
output "s3_frontend" {
  value = aws_s3_bucket.s3_frontend.bucket_regional_domain_name
}
