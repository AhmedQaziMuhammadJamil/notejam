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
  type        = string
  description = "(optional) describe your variable"
}

variable "cluster_size" {
  type        = string
  default     = "1"
  description = "(optional) describe your variable"
}

variable "instance_type" {
  type        = string
  default     = "cache.t3.micro"
  description = "(optional) describe your variable"
}


variable "family" {
  type        = string
  default     = "redis6.x"
  description = "(optional) describe your variable"
}

variable "at_rest_encryption_enabled" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "transit_encryption_enabled" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "cloudwatch_metric_alarms_enabled" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "engine_version" {
  type        = string
  default     = "6.x"
  description = "(optional) describe your variable"
}


variable "documentdb_master_password" {
  type        = string
  description = "(optional) describe your variable"
}