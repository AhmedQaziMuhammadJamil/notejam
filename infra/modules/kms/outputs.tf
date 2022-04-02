output "rds_key_arn" {
  value = module.rds_kms_key.key_arn
}

output "eks_key_arn" {
  value = module.eks_kms_key.key_arn
}