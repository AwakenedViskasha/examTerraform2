
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
# appel du modules networking lol
module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

module "database" {
  source    = "./modules/database"
  namespace = var.namespace
  dbname    = var.dbname
  tags = {
    name      = var.name
    namespace = var.namespace
  }
  mod_networking = module.networking
  depends_on = [
    module.networking
  ]
}
module "bastion" {
  source         = "./modules/bastion"
  namespace      = var.namespace
  mod_networking = module.networking
  depends_on = [
  module.networking]
}
module "asg" {
  source         = "./modules/asg"
  namespace      = var.namespace
  mod_networking = module.networking
  mod_database   = module.database
  depends_on = [
    module.networking,
    module.database
  ]
}

