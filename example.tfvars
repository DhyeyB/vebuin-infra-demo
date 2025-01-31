region              = "ap-south-1"
profile             = "your aws pofile name"
app_name            = "vebuin"
environment         = "prod"
az_count            = "2"
security_group_name = "vebuin-prod-sg"
description         = "security group for vebuin instance prod"
ingress_rules = [{
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}]
assume_role_policy_file_path = "<path of assume role policy>/assume_role_policy.json"
execution_policy_file_path   = "<path of execution policy>/execution_role_policy.json"
dockerfile_path              = "<path of docker file>"
upload_docker_image          = "yes"