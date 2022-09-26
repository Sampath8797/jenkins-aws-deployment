variable "app_name" {
  description = "Name of the Application"
  default     = "fouo"
}
variable "env_name" {
  description = "Name of the application's environment"
  default     = "jenkins-test"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
  default     = "FOUO"
}
variable "assume_role" {
  description = "IAM Assume Role ARN"
  default     = "arn:aws:iam::049243778959:role/IaC_Assume_Role"
}
variable "default_region" {
  description = "Application's default region"
  default     = "us-east-1"
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.1.0.0/16"
}
variable "az_count" {
  description = "Number of availablity zones"
  default     = 2
}
variable "app_service_port" {
  description = "Port which the application is exposed"
  default     = 8000
}
variable "db_port" {
  description = "Port which the DB is exposed"
  default     = 5432
}
variable "bastion_sg" {
  description = "Bastion Security Group ID"
  default     = "sg-00d42f05f011d65ff"
}
variable "main_domain_name" {
  description = "Main Host name"
  default     = "crystaldelta.net"
}
variable "wildcard_domain_name" {
  description = "Cloudfront domain name"
  default     = "*.fouo.crystaldelta.net"
}
variable "alb_domain_name" {
  description = "ALB DNS name"
  default     = "stg-api.fouo.crystaldelta.net"
}
variable "frontend_domain_name" {
  description = "Frontend DNS name"
  default     = "stg.fouo.crystaldelta.net"
}
variable "engine" {
  description = "RDS DB Engine"
  default     = "postgres"
}
variable "engine_version" {
  description = "RDS DB Engine version"
  default     = "13.4"
}
variable "db_instance_class" {
  description = "Instance class of the DB"
  default     = "db.t3.micro"
}
variable "master_user" {
  description = "Mysql DB username"
}
variable "master_password" {
  description = "Mysql DB password"
}
variable "allocated_storage" {
  description = "RDS Allocated Storage"
  default     = 20
}
variable "backup_retention_period" {
  description = "Number of days to backup the DB"
  default     = 7
}
variable "multi_az" {
  description = "Enabling multi availablity zone"
  default     = false
}
variable "s3_static" {
  description = "Frontend S3 Bucket regional domain name"
  default     = "fouo-stg-static-contents.s3.us-east-1.amazonaws.com"
}
variable "fargate_cpu" {
  description = "The number of cpu units used by the task."
  default     = 512
}
variable "fargate_memory" {
  description = "The amount (in MiB) of memory used by the task."
  default     = 1024
}
variable "launch_type" {
  description = "ECS launch type"
  default     = "FARGATE"
}
variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running."
  default     = 1
}
variable "soft_memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container."
  default     = 512
}
variable "principal_accounts" {
  description = "Accounts which are making request to this Key"
  default     = "arn:aws:iam::487068311512:root"
}
variable "accountID" {
  description = "AWS account ID"
  default     = "487068311512"
}
variable "IAMUser" {
  description = "IAM user for administrating"
  default     = "aws-infra-setup"
}
variable "tag" {
  description = "ECR image tag"
  default     = "latest"
}
