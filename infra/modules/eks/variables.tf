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
##########################flux####################33
variable "target_path" {
  type        = string
  default     = "notejam"
  description = "flux install target path"
}

variable "components_extra" {
  type        = list(string)
  default     =  ["image-reflector-controller","image-automation-controller"]
  description = "extra flux components"
}
variable "github_owner" {
  type = string
}
variable "github_token" {
  type = string
}
variable "repository_name" {
  type        = string
  default     = "flux-system"
  description = "github repository name"
}

variable "repository_visibility" {
  type        = string
  default     = "private"
  description = "How visible is the github repo"
}

variable "branch" {
  type        = string
  default     = "main"
  description = "branch name"
}
