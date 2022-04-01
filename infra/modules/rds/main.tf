resource "aws_db_parameter_group" "db-pg" {
  name        = "notejam-pg"
  family      = var.pgfamily
  description = "Parameter group for notejam"
  parameter {
    name         = "innodb_large_prefix"
    value        = 1
    apply_method = "pending-reboot"
  }
  tags = var.custom_tags
}

resource "aws_rds_cluster_parameter_group" "cpg" {
  name        = "notejam-cluster-pg"
  family      = var.pgfamily
  description = "Cluster Parameter group for notejam"
  parameter {
    name         = "binlog_format"
    value        = "MIXED"
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "innodb_large_prefix"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = 1
    apply_method = "pending-reboot"
  }
  tags = var.custom_tags
}

#Generate random password for Aurora DB
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

#Store data in parameter store
resource "aws_ssm_parameter" "username" {
  name        = "/notejam/aurora/masterusername"
  description = "RDS Username for notejam environment"
  type        = "SecureString"
  value       = var.db_username
  tags        = var.custom_tags
}

resource "aws_ssm_parameter" "password" {
  name        = "/notejam/aurora/password"
  description = "RDS Password for notejam environment"
  type        = "SecureString"
  value       = random_password.password.result
  tags        = var.custom_tags



}


module "rds-aurora" {
  source                 = "terraform-aws-modules/rds-aurora/aws"
  version                = "6.2.0"
  create_db_subnet_group = true
  create_security_group  = false
  create_random_password = false
  name                   = "notejam-db"
  engine                 = "aurora-postgresql"
  engine_version         = "11.12"
  instance_class         = "db.r6g.large"
  master_password        = random_password.password.result
  master_username        = var.db_username
  instances = {
    primary = {
      instance_class = "db.r6g.large"
    }
    secondary = {
      instance_class = "db.r6g.large"
    }
  }

  vpc_id  = var.vpc_id
   subnets = var.rds-subnets
  kms_key_id = var.kms_key_arn
  allowed_security_groups = [var.rds-sg]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = aws_db_parameter_group.db-pg.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cpg.name

  enabled_cloudwatch_logs_exports = ["postgresql"]
  tags                            = var.custom_tags
}

