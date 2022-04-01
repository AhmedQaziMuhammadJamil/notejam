variable "vpc_id" {
  type = string
}

variable "rds-subnets" {
}
variable "rds-sg" {
  type = string
}
//TODO get db username and password from terraform cloud
variable "db_username" {
  type    = string
  default = "master"

}

variable "pgfamily" {
  type    = string
  default = "aurora5.6"
}

variable "custom_tags" {
}

variable "kms_key_id" {
  
}