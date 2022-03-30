module "mod_vpc" {
  vpc_cidr = var.vpc_cidr
  source   = "./modules/vpc"
  env      = var.env
}

module "mod_sg" {
  source = "./modules/security-groups"
  env = var.env
  var_vpcid = module.mod_vpc.out_nl_vpcid
}