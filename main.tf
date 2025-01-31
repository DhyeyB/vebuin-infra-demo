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

module "iam_role" {
  source  = "app.terraform.io/bombay-softwares/infrastructure/aws//modules/iam_role"
  version = "0.2.0-prod.1"

  app_name                     = var.app_name
  env                          = var.environment
  assume_role_policy_file_path = var.assume_role_policy_file_path
  execution_policy_file_path   = var.execution_policy_file_path

}

module "ecr" {
  source = "./modules/ecr"

  app_name            = var.app_name
  env                 = var.environment
  region              = var.region
  dockerfile_path     = var.dockerfile_path
  upload_docker_image = var.upload_docker_image
  profile             = var.profile
}

module "ecs" {
  source = "./modules/ecs"

  app_name           = var.app_name
  env                = var.environment
  region             = var.region
  image_url          = module.ecr.image_url
  execution_role_arn = module.iam_role.role_arn
  task_role_arn      = module.iam_role.role_arn
  security_group_id  = [module.security.security_group_id]
  subnets_id         = [module.vpc.aws_public_subnet_id_1, module.vpc.aws_public_subnet_id_2]
  alb_tg_arn         = module.alb.target_group_arn
}

module "asg" {
  source = "./modules/asg"

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
}