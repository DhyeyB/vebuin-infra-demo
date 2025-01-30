region              = "ap-south-1"
profile             = "y  ofile name"
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
instance_ami   = "AMI ID"
instance_type  = "t2.micro"
ssh_public_key = "your ssh public key which you have created"

