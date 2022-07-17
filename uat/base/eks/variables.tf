variable "cluster_name" {
  type        = string
  description = "(optional) describe your variable"
}

/* variable "eks_managed_node_groups" {
    type = string
    description = "(optional) describe your variable"
} */

variable "autoscaling_average_cpu" {
  type        = string
  description = "(optional) describe your variable"
  default     = "90"
}

variable "vpc_id" {
  type        = string
  description = "(optional) describe your variable"
}

variable "nodegroup_subnets" {
  type        = list(any)
  description = "(optional) describe your variable"
}


variable "control_plane_subnet_ids" {
  type        = list(any)
  description = "(optional) describe your variable"
}
variable "alb_sg" {
  type        = string
  description = "(optional) describe your variable"
}

variable "common_tags" {

}
variable "env" {
  type        = string
  description = "(optional) describe your variable"
}

variable "worker_sg" {
  type        = string
  description = "(optional) describe your variable"
}

variable "key_name" {
  type = string
  description = "(optional) describe your variable"
}