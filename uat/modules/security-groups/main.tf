
module "alb_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "4.9.0"
  name                = local.alb_sg_name
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  tags                = var.common_tags
}

module "worker_nodes_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"
  name    = local.worker_sg_name
  vpc_id  = var.vpc_id
  #ingress_rules       = ["all-all"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.alb_sg.security_group_id
    },
  ]
  tags = var.common_tags
}

module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"
  name    = local.rds_sg_name
  vpc_id  = var.vpc_id
  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.worker_nodes_sg.security_group_id
    },
  ]
  tags = var.common_tags
}