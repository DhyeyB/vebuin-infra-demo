variable "instance_ami" {
  description = "Instance ami"
  type        = string
  nullable    = false
}

variable "instance_type" {
  description = "Instance type of EC2"
  type        = string
  nullable    = false
}

variable "security_group_id" {
  type        = list
  description = "List of security group id"
  nullable    = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  type        = string
}

variable "subnets_id" {
  type        = list
  description = "List of subnet id"
  nullable    = false
}

variable "target_group_arn" {
  description = "Target group arn"
  type        = list(string)
  nullable    = false
}