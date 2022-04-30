variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR for the notejam application Vpc"
  default     = "10.10.0.0/16"
}

variable "env" {
  type        = string
  description = "Env for the application"
  default     = "dev"
}


variable "github_owner" {
  type = string
}
variable "github_token" {
  type = string
}
variable "db_user" {
  type=string
}
variable "db_pass" {
  type =string 
}
variable "db_name" {
  type=string
}