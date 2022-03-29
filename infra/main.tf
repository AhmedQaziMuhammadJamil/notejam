module "mod_vpc" {
    var_vpc = var.vpc_cidr
    source = "./modules/vpc"
    env = var.env
}