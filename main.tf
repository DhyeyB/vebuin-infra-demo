provider "aws" {
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source = "./modules/vpc"

  app_name    = var.app_name
  environment = var.environment
  az_count    = var.az_count
}

module "security" {
  source = "./modules/security"

  security_group_name = var.security_group_name
  vpc_id              = module.vpc.vpc_id
  description         = var.description
  ingress_rules       = var.ingress_rules
  environment         = var.environment
  egress_rule         = var.egress_rule
}

module "alb" {
  source = "./modules/alb"

  app_name          = var.app_name
  vpc_id            = module.vpc.vpc_id
  security_group_id = [module.security.security_group_id]
  subnets_id        = [module.vpc.aws_public_subnet_id_1, module.vpc.aws_public_subnet_id_2]
}

module "asg" {
  source = "./modules/asg"

  instance_ami      = var.instance_ami
  instance_type     = var.instance_type
  security_group_id = [module.security.security_group_id]
  user_data = base64encode(templatefile("./userdata.sh", {
    ssh_public_key = var.ssh_public_key
  }))
  subnets_id       = [module.vpc.aws_public_subnet_id_1, module.vpc.aws_public_subnet_id_2]
  target_group_arn = [module.alb.target_group_arn]
}