variable "common_tags" {
}
variable "vpc_id" {
  type = string
}

variable "env" {
}


variable "alb_sg_name" {
}


variable "rds_sg_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "worker_node_sg" {
  type        = string
  description = "(optional) describe your variable"
}