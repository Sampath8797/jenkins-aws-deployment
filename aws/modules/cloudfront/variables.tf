variable "app_name" {
  description = "Name of the application"
}
variable "env_name" {
  description = "Name of the application's environment"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
variable "assume_role" {
  description = "IAM Assume Role ARN"
}
variable "main_domain_name" {
  description = "Main donain name from the Route 53"
}
variable "s3_static" {
  description = "URL of the S3 bucket"
}
variable "frontend_domain_name" {
  description = "domain name for the frontend host header"
}
variable "alb_domain_name" {
  description = "domain name for the ALB's host header"
}
variable "nv_cf_certificate" {
  description = "ACM certificate for CF"
}
variable "cf_logs_s3_bucket" {
  description = "Store CloudFront logs"
}
