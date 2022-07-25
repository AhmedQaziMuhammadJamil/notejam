output "cluster_id" {
  value = module.base.cluster_id
}


output "iam_role_vault_kms_unseal_arn" {
  value = module.vault_kms_unseal_oidc.this_iam_role_arn
}