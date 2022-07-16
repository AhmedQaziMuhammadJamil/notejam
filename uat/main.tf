module "mod_vpc" {
  source       = "./base/vpc"
  vpc_cidr     = var.vpc_cidr
  env          = var.env
  common_tags  = local.common_tags
  cluster_name = var.cluster_name
}


module "mod_sg" {
  source              = "./base/security-groups"
  common_tags         = local.common_tags
  alb_sg_name         = "alb-public"
  env                 = var.env
  vpc_id              = module.mod_vpc.vpc_id
  rds_sg_name         = "postgres"
  worker_node_sg_name = "eks-worker"
  redis_sg_name       = "redis"
  rabbitmq_sg_name    = "rabbitmq"
  efs_sg_name = "efs"
}

/* module "mod_eks" {
  source                   = "./base/eks"
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
  source         = "./base/rds"
  security_group = module.mod_sg.rds_sg
  kms_key        = module.rds_kms.key_arn
  db_subnets     = module.mod_vpc.db_subnets
  env            = var.env
  pg_password    = var.pg_password
} */

 module "alb_public" {
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
 

 module "alb_internal" {
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

module "mq_broker" {
  source = "cloudposse/mq-broker/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version     = "2.0.0"
  namespace                     = "eg"
  stage                         = var.env
  name                          = "mq-broker"
  apply_immediately             = true
  auto_minor_version_upgrade    = true
  deployment_mode               = "SINGLE_INSTANCE"
  engine_type                   = "RabbitMQ"
  engine_version                = "3.9.16"
  host_instance_type            = "mq.m5.large"
  publicly_accessible           = false
  general_log_enabled           = true
  audit_log_enabled             = false
  encryption_enabled            = false
  use_aws_owned_key             = false
  vpc_id                        = module.mod_vpc.vpc_id
  subnet_ids                    = [module.mod_vpc.db_subnets[0]]
  associated_security_group_ids = [module.mod_sg.rabbitmq_sg]
  create_security_group         = false

}

module "elasticache-redis" {
  source                        = "cloudposse/elasticache-redis/aws"
  version                       = "0.44.0"
  availability_zones            = data.aws_availability_zones.available.names
  vpc_id                        = module.mod_vpc.vpc_id
  associated_security_group_ids = [module.mod_sg.redis_sg]
  create_security_group         = false
  subnets                       = module.mod_vpc.elasticache_subnets
  replication_group_id          = "ezgen-uat"
  cluster_size                  = var.cluster_size
  instance_type                 = var.instance_type
  apply_immediately             = true
  automatic_failover_enabled    = false
  engine_version                = var.engine_version
  family                        = var.family
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled


  parameter = [
    {
      name  = "notify-keyspace-events"
      value = "lK"
    }
  ]
log_delivery_configuration = [
    {
      destination      = module.cloudwatch_logs.log_group_name
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "engine-log"
    }
  ]
  context = module.this.context

}

module "cloudwatch_logs" {
  source  = "cloudposse/cloudwatch-logs/aws"
  version = "0.6.5"

  context = module.this.context
}

module "this" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
   version = "0.25.0"
  namespace = "ezgen"
  stage     = "uat"
  name      = "redis"
}



module "efs_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "1.0.1"

  description        = "RDS"
  key_usage          = "ENCRYPT_DECRYPT"
  is_enabled         = true
  multi_region       = false
  key_owners         = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  key_administrators = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aqazi"]
  key_users          = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aqazi"]
  key_service_users  = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForAmazonElasticFileSystem"]

  # Aliases
  aliases = ["${var.env}-efs"]

  tags = local.common_tags
}


 module "efs" {
  source  = "cloudposse/efs/aws"
  name = "ezgen-${var.env}"
  namespace = "ezgen"
  version = "0.32.7"
  region  = var.region
  vpc_id  = module.mod_vpc.vpc_id
  subnets = module.mod_vpc.private_subnets
  environment = var.env
  kms_key_id = module.efs_kms.key_id
  associated_security_group_ids = module.mod_sg.efs_sg
  create_security_group =false

} 

module "route53_zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "2.9.0"
  zones = {
    "internal.easygenerator.com" = {
      comment = "internal easygenertor zone R53 UAT"
      tags = local.common_tags
    }

    "uat.internal.easygenerator.com" = {
      comment           = "uat route53 zone"
      tags = local.common_tags
    }
}



}




/* module "documentdb-cluster" {
  source  = "cloudposse/documentdb-cluster/aws"
  version = "0.15.0"
  cluster_size                    = var.cluster_size
  master_username                 = var.master_username
  master_password                 = var.master_password
  instance_class                  = var.instance_class
  db_port                         = var.db_port
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.subnets.private_subnet_ids
  zone_id                         = var.zone_id
  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  allowed_security_groups         = var.allowed_security_groups
  allowed_cidr_blocks             = var.allowed_cidr_blocks
  snapshot_identifier             = var.snapshot_identifier
  retention_period                = var.retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  cluster_parameters              = var.cluster_parameters
  cluster_family                  = var.cluster_family
  engine                          = var.engine
  engine_version                  = var.engine_version
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.kms_key_id
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  cluster_dns_name                = var.cluster_dns_name
  reader_dns_name                 = var.rea
} */




/* module "opensearch" {
  source  = "idealo/opensearch/aws"
  version = "1.0.0"
  # insert the 5 required variables here
} */










##Base system overlays--kustomize

