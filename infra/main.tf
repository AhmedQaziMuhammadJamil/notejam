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
 source = "./modules/kms"
 custom_tags = local.custom_tags
}


module "rds" {
  source      = "./modules/rds"
  vpc_id      = module.mod_vpc.out_nl_vpcid
  rds-subnets = module.mod_vpc.out_nl_rdssubnet
  rds-sg      = module.mod_sg.rds-sg
  custom_tags = local.custom_tags
  kms_key_arn = module.mod_kms.key_arn

}

module "mod_iam"{
  source = "./modules/iam"
  custom_tags = local.custom_tags
}


module "mod_ecr"{
  source = "./modules/ecr"
   custom_tags = local.custom_tags
   ecr-role-arn= module.mod_iam.ecr-role-arn
}
module "mod_waf"{
  source = "./modules/waf"
}