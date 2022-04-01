variable "vpc_id" {
  type = string
}

variable "rds-subnets" {
}
variable "rds-sg" {
  type=string
}
//TODO get db username and password from terraform cloud
variable "db_username" {
    type=string
    default = "master"
  
}