
terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "network" {
  source           = "./network"
  vpc_cidr         = var.vpc_cidr
  subnet_ranges    = var.subnet_ranges
  environment_name = var.environment_name
  region           = var.region
}

module "ecs" {
  source                 = "./ecs"
  region                 = var.region
  nginx_target_group_arn = module.network.nginx_target_group_arn
  public_subnet_ids      = module.network.public_subnet_ids
  vpc_id                 = module.network.vpc_id
  alb_sg_id              = module.network.alb_sg_id
}