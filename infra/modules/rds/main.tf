resource "aws_db_parameter_group" "db-pg" {
  name        = "notejam-pg"
  family      = var.pgfamily
  description = "Parameter group for notejam"
  /*  parameter {
    name         = "innodb_large_prefix"
    value        = 1
    apply_method = "pending-reboot"
  } */
  tags = var.custom_tags
}

resource "aws_rds_cluster_parameter_group" "cpg" {
  name        = "notejam-cluster-pg"
  family      = var.pgfamily
  description = "Cluster Parameter group for notejam"
  /*  parameter {
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
  } */
  tags = var.custom_tags
}

resource "aws_secretsmanager_secret" "rds-user" {
  name = "notejam-db-master-username"
}

resource "aws_secretsmanager_secret_version" "secret-username" {
  secret_id     = aws_secretsmanager_secret.rds-user.id
  secret_string = var.db_user
}


resource "aws_secretsmanager_secret" "rds-password" {
  name = "notejam-db-master-password"
}

resource "aws_secretsmanager_secret_version" "secret-password" {
  secret_id     = aws_secretsmanager_secret.rds-password.id
  secret_string = var.db_pass
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
  master_password        = var.db_pass
  master_username        = var.db_user
  database_name  = "notejam"
  instances = {
    writer = {
      instance_class = "db.t3.medium"
    }
    //TODO cost savings-revert later
   /*  reader = {
      instance_class = "db.t3.medium"
    } */

  }

  vpc_id                 = var.vpc_id
  subnets                = var.rds-subnets
  kms_key_id             = var.kms_key_arn
  vpc_security_group_ids = [var.rds-sg]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = aws_db_parameter_group.db-pg.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cpg.name

  enabled_cloudwatch_logs_exports = ["postgresql"]
  tags                            = var.custom_tags
}

