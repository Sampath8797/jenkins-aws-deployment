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
variable "wildcard_domain_name" {
  description = "Cloudfront domain name"
}