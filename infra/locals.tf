locals {
  common_tags = {
    created_by = "terraform"
    project = "easygenerator"
    environment = var.env
  }
}