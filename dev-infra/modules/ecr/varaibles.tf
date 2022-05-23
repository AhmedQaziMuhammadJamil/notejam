variable "custom_tags" {
  type = map(any)
}

variable "ecr-role-arn" {
  type = string

}
variable "env" {
  type = string

}