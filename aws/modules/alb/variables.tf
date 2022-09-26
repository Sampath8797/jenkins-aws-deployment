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
variable "public_subnet_1" {
  description = "Public subnet ID from the VPC"
}
variable "public_subnet_2" {
  description = "Public subnet ID from the VPC"
}
variable "alb_sg" {
  description = "ALB security group ID for ALB"
}
variable "vpc_id" {
  description = "VPC id which the security groups are going to launch"
}
variable "acm_certificate" {
  description = "ACM certificate ARN"
}
variable "alb_domain_name" {
  description = "domain name for the ALB's host header"
}
