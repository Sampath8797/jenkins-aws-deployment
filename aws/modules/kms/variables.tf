variable "app_name" {
  description = "Name of the application"
}
variable "env_name" {
  description = "Name of the application's environment"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
variable "principal_accounts" {
  description = "Accounts which are making request to this Key"
}
variable "accountID" {
  description = "AWS account ID"
}
variable "IAMUser" {
  description = "IAM user for administrating"
}