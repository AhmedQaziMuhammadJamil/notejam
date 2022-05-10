locals {
  custom_tags = {
    Owner       = "DevOps"
    Environment = "${var.env}"
    ManagedBy   = "Terraform"
    Project     = "NoteJam"
    
  }
  s3_name="pgsql-notejam-backup-${var.env}"
}