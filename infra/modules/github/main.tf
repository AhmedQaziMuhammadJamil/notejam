module "oidc-github" {
  source  = "unfunco/oidc-github/aws"
  version = "0.7.0"
  enabled = var.enabled
  create_oidc_provider          = var.create_oidc_provider
  force_detach_policies         = var.force_detach_policies
  github_thumbprint             = var.github_thumbprint
  iam_role_name                 = var.iam_role_name
  iam_role_path                 = var.iam_role_path
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_policy_arns          = [var.github_actions_ecr]
  github_organisation           = var.github_organisation
  github_repositories           = var.github_repositories
  max_session_duration          = var.max_session_duration
  tags                          = var.custom_tags
}

