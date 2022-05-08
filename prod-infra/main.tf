module "mod_vpc" {
  vpc_cidr    = var.vpc_cidr
  source      = "./modules/vpc"
  env         = var.env
  custom_tags = local.custom_tags
}

module "mod_sg" {
  source      = "./modules/security-groups"
  env         = var.env
  vpc_id      = module.mod_vpc.out_nl_vpcid
  custom_tags = local.custom_tags
}



module "mod_kms" {
  source      = "./modules/kms"
  custom_tags = local.custom_tags
   env         = var.env
}


  module "rds" {
  source      = "./modules/rds"
  vpc_id      = module.mod_vpc.out_nl_vpcid
  rds-subnets = module.mod_vpc.out_nl_rdssubnet
  rds-sg      = module.mod_sg.rds-sg
  custom_tags = local.custom_tags
  kms_key_arn = module.mod_kms.rds_key_arn
  db_pass = var.db_pass
  db_user = var.db_user
  db_name= var.db_name
  env         = var.env
  
} 

module "mod_iam" {
  source      = "./modules/iam"
  custom_tags = local.custom_tags
  ecr_repo_arn = module.mod_ecr.ecr_arn
  ecr_repository_name = module.mod_ecr.ecr_name
  env         = var.env
  s3_bucket_arn =  module.s3_bucket.s3_bucket_arn
    s3_kms_master_key_id = module.mod_kms.s3_key_arn
}


  module "mod_ecr" {
  source       = "./modules/ecr"
  custom_tags  = local.custom_tags
  ecr-role-arn = module.mod_iam.ecr-role-arn
  env         = var.env
} 

 module "mod_waf" {
  source = "./modules/waf"
   env         = var.env
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.s3_name
  acl    = "private"
  tags = local.custom_tags
  force_destroy = true
  versioning = {
    enabled = false
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.mod_kms.s3_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

}

####Should only be created in single env(Dev or Prod),we can't create multiple oidc of the same audience
/* module "mod_github" {
  source = "./modules/github"
  github_actions_ecr = module.mod_iam.github_actions_ecr
  custom_tags = local.custom_tags

} 
 */

module "mod_eks" {
  source          = "./modules/eks"
  cluster_kms     = module.mod_kms.eks_key_arn
  custom_tags     = local.custom_tags
  vpc_id          = module.mod_vpc.out_nl_vpcid
  private_subnets = module.mod_vpc.out_nl_privatesubnet
  worker-sg       = module.mod_sg.worker-sg
  env = var.env
}

  
   module "mod_flux" {
  source = "./modules/flux"
  cluster_id= module.mod_eks.cluster_id
  cluster_auth = module.mod_eks.cluster_auth
  host=module.mod_eks.eks_host
  cluster_ca_certificate = module.mod_eks.cluster_ca_certificate
  token=module.mod_eks.token
   github_owner = var.github_owner
  github_token = var.github_token
  env = var.env
}   
   