
module "ecr" {
  source                 = "cloudposse/ecr/aws"
  version                = "0.33.0"
  namespace              = "notejam"
  stage                  = var.env
  name                   = "ecr-registry"
  principals_full_access = [var.ecr-role-arn]
  scan_images_on_push    = true
  tags                   = var.custom_tags
}
#TODO: -change-ecr-repo name in tf and flux manifest