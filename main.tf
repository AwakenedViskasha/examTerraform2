
provider "aws" {
  region     = "eu-west-3"
  access_key = "AKIAUAZADBSFCJIPTVEL" # la clé d’accès crée pour l'utilisateur qui sera utilisé par terraform
  secret_key = "XylNEunqjeWfk62dBAdp1kl92l/pqx7zQvAxAsY5"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
# appel du modules networking
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
}


