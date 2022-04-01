# IAM Role to be granted ECR permissions
 
 //TODO using oidc push images to github
/*  data "aws_iam_role" "ecr" {
  name = "ecr"
}
  */
module "ecr" {
  source = "cloudposse/ecr/aws"
  version     = "0.33.0"
  namespace              = "notejam"
  stage                  = "test"
  name                   = "ecr"
  principals_full_access = [var.ecr-role-arn]
  scan_images_on_push = true
  tags=var.custom_tags
}