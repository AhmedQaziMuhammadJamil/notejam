output "ecr-role-arn" {
  value = module.iam.iam_role_arn
}
output "github_actions_ecr" {
  value= aws_iam_policy.github_actions.arn
}