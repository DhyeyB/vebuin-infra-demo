variable "app_name" {
  description = "Application Name"
  type        = string
  nullable    = false
}

variable "vpc_id" {
  type        = string
  description = "Network VPC ID"
  nullable    = false
}

variable "security_group_id" {
  type        = list
  description = "List of security group id"
  nullable    = false
}

variable "subnets_id" {
  type        = list
  description = "List of subnet id"
  nullable    = false
}