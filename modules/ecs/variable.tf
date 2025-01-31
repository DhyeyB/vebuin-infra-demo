variable "app_name" {
  description = "Name of deployed Application"
  type = string
}

variable "env" {
  description = "Deployment Server Environment Name: prod/staging/dev"
  type = string
}

variable "region" {
  description = "Region where application to be deployed"
  type        = string
}

variable "image_url" {
  description = "Image url"
  type        = string
}

variable "execution_role_arn" {
  description = "Image url"
  type        = string
}

variable "task_role_arn" {
  description = "Image url"
  type        = string
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

variable "alb_tg_arn" {
  description = "ALB Target group ARN"
  type        = string
}
