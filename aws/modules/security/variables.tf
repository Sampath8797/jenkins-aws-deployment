variable "app_name" {
  description = "Name of the application"
}
variable "env_name" {
  description = "Name of the application's environment"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
variable "vpc_id" {
  description = "VPC id which the security groups are going to launch"
}
variable "app_service_port" {
  description = "Port which the application is exposed"
}
variable "db_port" {
  description = "Port which the DB is exposed"
}
variable "bastion_sg" {
  description = "Bastion Security Group ID"
}
