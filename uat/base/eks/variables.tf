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
  type        = string
  description = "(optional) describe your variable"
}

variable "public_target_group_arns" {

}


### flux variables
variable "flux_github_owner" {
  type = string
  description = "(optional) describe your variable"
}

variable "flux_github_token" {
  type = string
  description = "(optional) describe your variable"
}

variable "target_path" {
  type        = string
  default     = "clusters/services"
  description = "flux install target path"
}

variable "components_extra" {
  type        = list(string)
  default     = ["image-reflector-controller", "image-automation-controller"]
  description = "extra flux components"
}

variable "flux_repository_name" {
  type        = string
  default     = "operations-k8s"
  description = "github repository name"
}

variable "flux_repository_visibility" {
  type        = string
  default     = "private"
  description = "How visible is the github repo"
}

variable "flux_branch" {
  type        = string
  default     = "main"
  description = "branch name"
}
