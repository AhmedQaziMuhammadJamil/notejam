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

variable "worker_node_sg_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "redis_sg_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "rabbitmq_sg_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "efs_sg_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "documentdb_sg_name" {
  type        = string
  description = "(optional) describe your variable"
}