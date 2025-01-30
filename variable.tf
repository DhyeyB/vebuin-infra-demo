variable "region" {
  description = "Region where application to be deployed"
  type        = string
}

variable "profile" {
  description = "profile name of your aws account"
  type        = string
}

variable "app_name" {
  description = "Application Name"
  type        = string
  nullable    = false
}

variable "environment" {
  description = "Deployment Server Environment Name: prod/staging/dev"
  nullable    = false
  type        = string
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  type        = string
  nullable    = false
}

variable "security_group_name" {
  description = "Securtiy Group Name"
  type        = string
  nullable    = false
}

variable "description" {
  type        = string
  description = "Security Group Description"
}

variable "ingress_rules" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    self            = optional(bool)
    security_groups = optional(list(string))
    cidr_blocks     = optional(list(string))
    // Add any other ingress rule attributes here
  }))
  description = "The list of ingress rules for the security group"
}

variable "egress_rule" {
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  description = "The egress rule for the security group"
}

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

variable "ssh_public_key" {
  description = "Public key"
  type        = string
  nullable    = false
  default     = ""
}

