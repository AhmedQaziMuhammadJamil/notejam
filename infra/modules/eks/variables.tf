variable "cluster_kms" {
}

variable "custom_tags" {
}

variable "vpc_id" {

}

variable "private_subnets" {

}
variable "worker-sg" {

}

variable "target_path" {
  type        = string
  default     = "notejam"
  description = "flux install target path"
}

variable "components_extra" {
  type        = list(string)
  default     =  []
  description = "extra flux components"
}