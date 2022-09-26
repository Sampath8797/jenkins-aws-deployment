variable "app_name" {
  description = "Name of the application"
}
variable "env_name" {
  description = "Name of the application's environment"
}
variable "vpc_cidr" {
  description = "CIDR address for the VPC"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
variable "az_count" {
  description = "Number of availability zones"
}