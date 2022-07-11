variable "vpc_cidr" {
  type        = string
  description = "vpc-cidr for the module"
}

variable "env" {
  type        = string
  description = "env type "

}


variable "common_tags" {
  type        = map(any)
  description = "tags"
}


variable "cluster_name" {
  type        = string
  description = "(optional) describe your variable"
}