output "vpc" {
  value = module.vpc
}
output "awsSG" {
  value = { sgForPetclinicApp = aws_security_group.sgForPetclinicApp
  sg_pub_id = aws_security_group.allow_ssh_pub }
}
output "sg_pub_id" {
  value = aws_security_group.allow_ssh_pub.id
}

output "sgForPetclinicApp" {
  value = aws_security_group.sgForPetclinicApp.id
}

output "sgForPetclinicDB" {
  value = aws_security_group.sgForPetclinicDB.id
}

output "forLB" {
  value = aws_security_group.forLB.id
}


