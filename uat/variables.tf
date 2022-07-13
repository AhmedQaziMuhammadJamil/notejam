variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR (Required) to create VPC"
}

variable "region" {
  type        = string
  description = "region to create resources"
}

variable "env" {
  type        = string
  description = "env types"
}

variable "cluster_name" {
  type        = string
  description = "(optional) describe your variable"
} 


variable "pg_password" {
  type = string
  description = "(optional) describe your variable"
}