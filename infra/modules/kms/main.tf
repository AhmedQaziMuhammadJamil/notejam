module "rds_kms_key" {
  source = "cloudposse/kms-key/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version                 = "0.12.1"
  enabled                 = true
  name                    = "rds-key"
  description             = "KMS key for RDS"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  alias                   = "alias/rds-cmk"
  multi_region            = true
  tags                    = var.custom_tags
}


module "eks_kms_key" {
  source = "cloudposse/kms-key/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version                 = "0.12.1"
  enabled                 = true
  name                    = "eks-key"
  description             = "KMS key for EKS"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  alias                   = "alias/eks-cmk"
  multi_region            = true
  tags                    = var.custom_tags
}

module "s3_kms_key" {
  source = "cloudposse/kms-key/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version                 = "0.12.1"
  enabled                 = true
  name                    = "s3-key"
  description             = "KMS key for S3 objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  alias                   = "alias/s3-cmk"
  multi_region            = true
  tags                    = var.custom_tags
}