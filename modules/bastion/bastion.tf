module "ec2_bastion" {
  source                      = "cloudposse/ec2-bastion-server/aws"
  version                     = "0.30.1"
  name                        = "${var.namespace}-bastion"
  enabled                     = true
  instance_type               = "t2.micro"
  security_groups             = [var.mod_networking.sgForPetclinicApp, var.mod_networking.sgForPetclinicDB, var.mod_networking.forLB]
  subnets                     = var.mod_networking.vpc.public_subnets
  key_name                    = "PourUserTest2"
  vpc_id                      = var.mod_networking.vpc.vpc_id
  associate_public_ip_address = true
}
