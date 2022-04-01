locals {
  custom_tags = {
    Owner       = "DevOps"
    Environment = "${var.env}"
    ManagedBy   = "Terraform"
    Project     = "NoteJam"
  }
}