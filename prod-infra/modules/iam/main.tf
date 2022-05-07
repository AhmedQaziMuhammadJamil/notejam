
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
   ## resources = [var.ecr_repo_arn] single repo
      resources = ["*"] ## multiple repos-including-dev-stage-prod
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

