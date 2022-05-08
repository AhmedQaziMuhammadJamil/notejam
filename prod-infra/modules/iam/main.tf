locals {
  default ={
  ACCESS_KEY_ID = sensitive(module.iam_user.iam_access_key_id)
  AWS_SECRET_ACCESS_KEY =sensitive(module.iam_user.iam_access_key_secret)
  }
  
}
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


module "iam_user" {
  source                            = "terraform-aws-modules/iam/aws//modules/iam-user"
  version                           = "4.17.2"
  name = "S3-backup-cronjob-${var.env}"
  create_iam_user_login_profile = false
  create_iam_access_key         = true
  tags = var.custom_tags
  force_destroy = true
}

resource "aws_secretsmanager_secret" "s3_user_ak" {
  name = "notejam-${var.env}-s3-cronjob-user-ak"
   recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "access_key" {
  secret_id     = aws_secretsmanager_secret.s3_user_ak.id
  secret_string = jsonencode(local.default)
 
}

resource "aws_secretsmanager_secret" "s3_user_sk" {
  name = "notejam-${var.env}-s3-cronjob-user-sk"
   recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret-key" {
  secret_id     = aws_secretsmanager_secret.s3_user_sk.id
  secret_string = jsonencode(local.default)
}



module "iam-policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.24.0"
  create_policy=true
  description="IAM Policy for S3 cronjob user"
  name = "s3-pgsql-backup-cronjob-${var.env}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AllowAttachmentBucketWrite",
        "Effect": "Allow",
        "Action": [
            "s3:PutObject",
            "kms:Decrypt",
            "s3:AbortMultipartUpload",
            "kms:Encrypt",
            "kms:GenerateDataKey"
        ],
        "Resource": [
            "${var.s3_bucket_arn}/*",
            "${var.s3_kms_master_key_id}"
        ]
    }
  ]
}
EOF
  tags=var.custom_tags 
}

resource "aws_iam_user_policy_attachment" "s3-policy-attach" {
  user       = module.iam_user.iam_user_name
  policy_arn = module.iam-policy.arn
}
