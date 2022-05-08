variable "env" {
  
}
variable "cluster_id" {
  
}

variable "cluster_auth" {
  
}


variable "host" {
  
}
variable "token" {
  
}

variable "cluster_ca_certificate" {
  
}

variable "target_path" {
  type        = string
  default     = "clusters/services"
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
  default     = "operations-k8s-dev"
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

