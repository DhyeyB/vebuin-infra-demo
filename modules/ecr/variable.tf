variable "app_name" {
  description = "Name of deployed Application"
  type = string
}

variable "env" {
  description = "Deployment Server Environment Name: prod/staging/dev"
  type = string
}

variable "region" {
  description = "Region where application will be deployed"
  type = string
}

variable "upload_docker_image" {
    description = "If you want to upload docker image on ECR then value should not be null"
    type = string
    default = null
}

variable "dockerfile_path" {
    description = "Enter the path of the dockerfile from which you need to create docker image"
    type = string
    default = null
}

variable "profile" {
  description = "profile name of your aws account"
  type        = string
}