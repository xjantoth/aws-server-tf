provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_vpc" "default" {
  default = "true"
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

module "aws_alb_security_group" {
  source      = "./modules/aws_alb_security_group"
  vpc_id      = data.aws_vpc.default.id
  custom_tags = var.custom_tags
}

module "aws_alb" {
  source                        = "./modules/aws_alb"
  vpc_id                        = data.aws_vpc.default.id
  custom_tags                   = var.custom_tags
  subnet_ids                    = data.aws_subnet_ids.default.ids
  aws_instance_certification_id = module.aws_server.aws_instance_certification_id
  alb_security_group_id         = module.aws_alb_security_group.alb_security_group_id
}

module "aws_server_security_group" {
  source                = "./modules/aws_server_security_group"
  vpc_id                = data.aws_vpc.default.id
  custom_tags           = var.custom_tags
  alb_security_group_id = module.aws_alb_security_group.alb_security_group_id
}

module "aws_server" {
  source                     = "./modules/aws_server"
  ssh_public_key             = "${var.ssh_public_key}"
  initial_script             = var.initial_script
  server_security_group_name = module.aws_server_security_group.server_security_group_name
  custom_tags                = var.custom_tags
  number_of_inatances        = var.number_of_inatances
}

