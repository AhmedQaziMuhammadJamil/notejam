variable "vpc_id" {
  type = string
}

variable "rds-subnets" {
}
variable "rds-sg" {
  type = string
}
//TODO get db username and password from terraform cloud


variable "pgfamily" {
  type    = string
  default = "aurora-postgresql11"
}

variable "custom_tags" {
}

variable "kms_key_arn" {

}
variable "db_pass" {
  type    = string
}

variable "db_user" {
  type    = string
}
variable "db_name" {
  type=string
}
variable "env" {
  type = string
}