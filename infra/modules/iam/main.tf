
module "iam" {
  source                            = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                           = "4.17.2"
  number_of_custom_role_policy_arns = 1
  create_role                       = true
  create_instance_profile           = true
  role_name                         = "ecr-${var.env}"
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  ]

  trusted_role_arns = [
    "arn:aws:iam::003767002475:role/eksServiceRole"
  ]
  tags = var.custom_tags
  
}





data "aws_iam_policy_document" "source_policy_document_github" {
  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }
}



resource "aws_iam_policy" "github_actions" {
  name        = "github-actions-${var.ecr_repository_name}"
  description = "Grant Github Actions the ability to push to ${var.ecr_repository_name}"
  policy      = data.aws_iam_policy_document.source_policy_document_github.json
  tags = var.custom_tags
}

module "iam_user" {
  source                            = "terraform-aws-modules/iam/aws//modules/iam-user"
  version                           = "4.17.2"
  name = "S3-backup-cronjob-${var.env}"
  create_iam_user_login_profile = false
  create_iam_access_key         = true
  tags = var.custom_tags
}
resource "aws_secretsmanager_secret" "iam-s3-user" {
  name = "notejam-${var.env}-s3-cronjob-user"
   recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret-name" {
  secret_id     = aws_secretsmanager_secret.iam-s3-user.id
  secret_string = jsonencode(module.iam_user.iam_access_key_id)
}
