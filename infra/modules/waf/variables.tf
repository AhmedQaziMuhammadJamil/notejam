
//TODO uncomment load_balancer
/* variable "load_balancer_arn" {
  type = map(any)
} */
variable "waf_name" {
  type=string
  default="NoteJam-Waf"
}
