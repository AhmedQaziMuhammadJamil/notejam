
module "iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.17.2"
  number_of_custom_role_policy_arns = 1
  create_role             = true
  create_instance_profile = true
  role_name   = "ecr"
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  ]

  trusted_role_arns = [
    "arn:aws:iam::003767002475:role/eksServiceRole"
  ]
  tags=var.custom_tags
  # insert the 1 required variable here
}
//TODO create oidc for github for ECR
