module "mod_vpc" {
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
  worker_node_sg_name = "eks-worker"
  redis_sg_name  = "redis" 
  rabbitmq_sg_name = "rabbitmq"
}

/* module "mod_eks" {
  source                   = "./modules/eks"
  env                      = var.env
  common_tags              = local.common_tags
  cluster_name             = var.cluster_name
  vpc_id                   = module.mod_vpc.vpc_id
  nodegroup_subnets        = module.mod_vpc.private_subnets
  control_plane_subnet_ids = module.mod_vpc.eks_controlplane_eni_subnets
  alb_sg                   = module.mod_sg.alb_sg
  worker_sg               = module.mod_sg.worker_sg
  
} */

module "rds_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "1.0.1"

  description        = "RDS"
  key_usage          = "ENCRYPT_DECRYPT"
  is_enabled         = true
  multi_region       = false
  key_owners         = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  key_administrators = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aqazi"]
  key_users          = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aqazi"]
  key_service_users  = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"]

  # Aliases
  aliases = ["${var.env}-rds"]

  tags = local.common_tags
}


/* module "mod_rds" {
  source         = "./modules/rds"
  security_group = module.mod_sg.rds_sg
  kms_key        = module.rds_kms.key_arn
  db_subnets     = module.mod_vpc.db_subnets
  env            = var.env
  pg_password    = var.pg_password
} */

/* module "alb_public" {
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

/* module "alb_internal" {
  source          = "terraform-aws-modules/alb/aws"
  version         = "6.10.0"
  name            = "public-${var.env}"
  subnets         = module.mod_vpc.public_subnets
  vpc_id          = module.mod_vpc.vpc_id
  security_groups = [module.mod_sg.alb_sg]
  tags = merge( 
    local.common_tags,
    {
    "ingress.k8s.aws/stack"    = "internal"
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "elbv2.k8s.aws/cluster"    = var.cluster_name
  }
  )
}
 */
module "mq_broker" {
    source = "cloudposse/mq-broker/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"

    namespace                  = "eg"
    stage                      =  var.env
    name                       = "mq-broker"
    apply_immediately          = true
    auto_minor_version_upgrade = true
    deployment_mode            = "SINGLE_INSTANCE"
    engine_type                = "RabbitMQ"
    engine_version             = "3.9.16"
    host_instance_type         = "mq.m5.large"
    publicly_accessible        = false
    general_log_enabled        = true
    audit_log_enabled          = false
    encryption_enabled         = false
    use_aws_owned_key          = false
    vpc_id                     = module.mod_vpc.vpc_id
    subnet_ids                 = [module.mod_vpc.db_subnets[0]]
    associated_security_group_ids = [module.mod_sg.rabbitmq_sg]
    create_security_group            = false

  }



module "elasticache-redis" {
  source  = "cloudposse/elasticache-redis/aws"
  version = "0.44.0"
  availability_zones               = data.aws_availability_zones.available.names
  vpc_id                           = module.mod_vpc.vpc_id
  associated_security_group_ids          = [module.mod_sg.redis_sg]
  create_security_group            = false
  subnets                          = module.mod_vpc.elasticache_subnets
  replication_group_id             = "ezgen-uat"
  cluster_size                     = var.cluster_size
  instance_type                    = var.instance_type
  apply_immediately                = true
  automatic_failover_enabled       = false
  engine_version                   = var.engine_version
  family                           = var.family
  at_rest_encryption_enabled       = var.at_rest_encryption_enabled
  transit_encryption_enabled       = var.transit_encryption_enabled
 

  parameter = [
    {
      name  = "notify-keyspace-events"
      value = "lK"
    }
  ]

    context = module.this.context

}


module "this" {
  source  = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  namespace  ="ezgen"
  stage      = "uat"
  name       = "uat"
}

##Base system overlays--kustomize

