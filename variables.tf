variable "namespace" {
  description = "L'espace de noms de projet à utiliser pour la dénomination unique des ressources"
  default     = "Datascientest"
  type        = string
}
variable "name" {
  description = "le nom du projet"
  type        = string
  default     = "petclinic"
}
variable "region" {
  description = "AWS région"
  default     = "eu-west-3"
  type        = string
}

variable "dbname" {
  description = "Nom de la base de donnée petclinic"
  default     = "petclinicdb"
  type        = string
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}
