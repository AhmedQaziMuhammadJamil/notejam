variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR for the notejam application Vpc"
  default     = "192.168.0.0/16"
}

variable "env" {
  type        = string
  description = "Env for the application"
  default     = "prod"
}


variable "github_owner" {
  type = string
}
variable "github_token" {
  type = string
}
variable "db_user" {
  type = string
}
variable "db_pass" {
  type = string
}
variable "db_name" {
  type = string
}
variable "var_region" {
  type    = string
  default = "eu-west-1"
}