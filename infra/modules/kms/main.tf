    module "kms_key" {
      source = "cloudposse/kms-key/aws"
      # Cloud Posse recommends pinning every module to a specific version
      version = "0.12.1"
      enabled =  true
      name                    = "rds-key"
      description             = "KMS key for RDS"
      deletion_window_in_days = 10
      enable_key_rotation     = true
      alias                   = "alias/rds-cmk"
      multi_region = true
      tags = var.custom_tags
    }