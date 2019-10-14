provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "aws_server" {
  source         = "./modules/aws_server"
  ssh_public_key = "${var.ssh_public_key}"
  vpc_id         = var.vpc_id
  initial_script = var.initial_script

}
