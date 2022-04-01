module "mod_vpc" {
  vpc_cidr = var.vpc_cidr
  source   = "./modules/vpc"
  env      = var.env
}

module "mod_sg" {
  source = "./modules/security-groups"
  env = var.env
  vpc_id = module.mod_vpc.out_nl_vpcid
}


module "rds" {
  source = "./modules/rds"
  env=var.env
  vpc_id = module.mod_vpc.out_nl_vpcid
  rds-subnets =module.mod_vpc.out_nl_rdssubnet
  rds-sg= module.mod_sg.rds-sg
}