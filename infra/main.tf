module "mod_vpc" {
    vpc_cidr = var.vpc_cidr
    source = "./modules/vpc"
    env = var.env
}