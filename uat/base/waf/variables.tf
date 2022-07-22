variable "alb_arn" {
    type = string
    description = "(optional) describe your variable"
}

variable "env" {
    type = string
    description = "(optional) describe your variable"
}
variable "common_tags" {
  
}

variable "cloudflare_ipv4" {
    type = list
    description = "(optional) describe your variable"
}
variable "cloudflare_ipv6" {
    type = list
    description = "(optional) describe your variable"
}