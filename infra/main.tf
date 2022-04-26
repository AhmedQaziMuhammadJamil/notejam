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
}


 module "rds" {
  source      = "./modules/rds"
  vpc_id      = module.mod_vpc.out_nl_vpcid
  rds-subnets = module.mod_vpc.out_nl_rdssubnet
  rds-sg      = module.mod_sg.rds-sg
  custom_tags = local.custom_tags
  kms_key_arn = module.mod_kms.rds_key_arn

}

module "mod_iam" {
  source      = "./modules/iam"
  custom_tags = local.custom_tags
  ecr_repo_arn = module.mod_ecr.ecr_arn
  ecr_repository_name = module.mod_ecr.ecr_name
}


 module "mod_ecr" {
  source       = "./modules/ecr"
  custom_tags  = local.custom_tags
  ecr-role-arn = module.mod_iam.ecr-role-arn
} 
 module "mod_waf" {
  source = "./modules/waf"
}
 
module "mod_eks" {
  source          = "./modules/eks"
  cluster_kms     = module.mod_kms.eks_key_arn
  custom_tags     = local.custom_tags
  vpc_id          = module.mod_vpc.out_nl_vpcid
  private_subnets = module.mod_vpc.out_nl_privatesubnet
  worker-sg       = module.mod_sg.worker-sg
  github_owner = var.github_owner
  github_token = var.github_token
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
}   
   
module "mod_github" {
  source = "./modules/github"
  github_actions_ecr = module.mod_iam.github_actions_ecr

}