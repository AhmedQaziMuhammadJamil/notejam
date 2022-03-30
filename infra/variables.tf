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