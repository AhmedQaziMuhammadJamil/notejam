/* module "mod_vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  env          = var.env
  common_tags  = local.common_tags
  cluster_name = var.cluster_name
}


module "mod_sg" {
  source         = "./modules/security-groups"
  common_tags    = local.common_tags
  alb_sg_name    = "alb-public"
  env            = var.env
  vpc_id         = module.mod_vpc.vpc_id
  rds_sg_name    = "postgres"
  worker_node_sg = "eks-worker"
}

module "mod_eks" {
  source                   = "./modules/eks"
  env                      = var.env
  common_tags              = local.common_tags
  cluster_name             = var.cluster_name
  vpc_id                   = module.mod_vpc.vpc_id
  nodegroup_subnets        = module.mod_vpc.private_subnets
  control_plane_subnet_ids = module.mod_vpc.eks_controlplane_eni_subnets
  alb_sg                   = module.mod_sg.alb_sg
  worker_sg               = module.mod_sg.worker_sg
  
}
 */
module "rds_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "1.0.1"
  
  description = "RDS"
  key_usage   = "ENCRYPT_DECRYPT"
  is_enabled              = true
  multi_region            = false

  # Policy
  enable_default_policy                  = true
  //key_administrators = ["arn:aws:iam::003767002475:user/aqazi"]
  //key_users          = ["arn:aws:iam::003767002475:user/aqazi"]
 // key_service_users  = ["arn:aws:iam::003767002475:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"]

  # Aliases
  aliases = ["uat/rds"]

  tags = local.common_tags
}
/* module "mod_rds" {
  source = "./modules/rds"
  
} */


/* module "alb" {
  source          = "terraform-aws-modules/alb/aws"
  version         = "6.10.0"
  name            = "public-${var.env}"
  subnets         = module.mod_vpc.public_subnets
  vpc_id          = module.mod_vpc.vpc_id
  security_groups = [module.mod_sg.alb_sg]
  tags = merge( 
    local.common_tags,
    {
    "ingress.k8s.aws/stack"    = "public"
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "elbv2.k8s.aws/cluster"    = var.cluster_name
  }
  )
}
 */




##Base system overlays--kustomize

