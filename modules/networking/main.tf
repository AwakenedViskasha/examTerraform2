

# recupère dynamiquement les zones de disponibilités
data "aws_availability_zones" "available" {}

# appel du module vpc qu'on va importer grâce à la commande terraform init, le lien du module vous fournit une documentation du module vpc "terraform-aws-modules/vpc/aws"
module "vpc" {
  source          = "terraform-aws-modules/vpc/aws" #chemin depuis le registre .s'il était en local on aurait du écrire "./terraform-aws-modules/vpc/aws"
  name            = "${var.namespace}-vpc"
  cidr            = "10.0.0.0/16"
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  #assign_generated_ipv6_cidr_block = true
  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
}

# SG pour autoriser les connexions SSH depuis n'importe quel hôte
resource "aws_security_group" "allow_ssh_pub" {
  name        = "${var.namespace}-allow_ssh"
  description = "Autoriser le trafic entrant SSH et HTTP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH depuis Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP depuis Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.namespace}-allow_ssh_pub"
  }
}

#SG pour autoriser uniquement les connexions SSH à partir de sous-réseaux publics VPC
resource "aws_security_group" "sgForPetclinicApp" {
  name        = "${var.namespace}-sgForPetclinicApp"
  description = "Autoriser le trafic entrant SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH uniquement a partir de clients VPC internes"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    description = "HTTP uniquement a partir de clients VPC internes"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-sgForPetclinicApp"
  }
}

#SG pour autoriser uniquement les connexions SSH à partir de sous-réseaux publics VPC
resource "aws_security_group" "sgForPetclinicDB" {
  name        = "${var.namespace}-sgForPetclinicDB"
  description = "Autoriser le trafic entrant SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH uniquement a partir de clients VPC internes"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    description = "HTTP uniquement a partir de clients VPC internes"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-sgForPetclinicDB"
  }
}
