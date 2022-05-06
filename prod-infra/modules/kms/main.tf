module "rds_kms_key" {
  source = "cloudposse/kms-key/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version                 = "0.12.1"
  enabled                 = true
  name                    = local.rds_key_name
  description             = "KMS key for RDS"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/rds-cmk-${var.env}"
  multi_region            = true
  tags                    = var.custom_tags
}


module "eks_kms_key" {
  source = "cloudposse/kms-key/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version                 = "0.12.1"
  enabled                 = true
  name                    = local.eks_key_name
  description             = "KMS key for EKS"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/eks-cmk-${var.env}"
  multi_region            = true
  tags                    = var.custom_tags
}

module "s3_kms_key" {
  source = "cloudposse/kms-key/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version                 = "0.12.1"
  enabled                 = true
  name                    = local.s3_key_name
  description             = "KMS key for S3 objects"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/s3-cmk-${var.env}"
  multi_region            = true
  tags                    = var.custom_tags
}