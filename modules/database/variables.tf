variable "namespace" {
  type = string
}

variable "dbname" {
  type    = string
  default = "database"
}

variable "instance_class" {
  type    = string
  default = "db.t3.small"
}

variable "tags" {
  type    = map(any)
  default = { name = "lol" }
}

variable "vpc_id" {
  type    = string
  default = ""
}
variable "db_subnet_group_name" {
  type    = list(string)
  default = []
}
variable "allowed_security_groups" {
  type    = list(string)
  default = []
}
variable "allowed_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "mod_networking" {
  type = any
}
locals {
  vars = {
    db_endpoint = "${module.aurora.cluster_endpoint}"
  }
}
