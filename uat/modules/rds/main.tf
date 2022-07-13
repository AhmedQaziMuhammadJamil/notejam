


module "rds" {
  source                                 = "terraform-aws-modules/rds/aws"
  version                                = "4.5.0"
  identifier                             = lower("ezgen-pgsql-${var.env}")
  engine                                 = "postgres"
  engine_version                         = "14.1"
  family                                 = "postgres14"
  major_engine_version                   = "14"
  instance_class                         = "db.m5.large"
  multi_az                               = false
  allocated_storage                      = 20
  max_allocated_storage                  = 650
  storage_encrypted                      = true
  copy_tags_to_snapshot                  = true
  kms_key_id                             = var.kms_key
  username                               = "ezgenuat"
  password                               = var.pg_password
  port                                   = 5432
  create_db_subnet_group                 = true
  db_subnet_group_name                   = lower("ezgen-${var.env}")
  subnet_ids                             = var.db_subnets
  vpc_security_group_ids                 = [var.security_group]
  maintenance_window                     = "Mon:22:00-Mon:23:00"
  backup_window                          = "23:00-02:00"
  backup_retention_period                = 30
  skip_final_snapshot                    = false
  deletion_protection                    = true
  performance_insights_enabled           = true
  performance_insights_retention_period  = 7
  performance_insights_kms_key_id        = var.kms_key
  create_monitoring_role                 = true
  monitoring_interval                    = 60
  parameter_group_name                   = lower("ezgen-${var.env}")
  monitoring_role_name                   = var.env
  auto_minor_version_upgrade             = true
  apply_immediately                      = false
  create_cloudwatch_log_group            = true
  cloudwatch_log_group_retention_in_days = 90
  cloudwatch_log_group_kms_key_id        = var.kms_key
  parameters = [{
    name  = "autovacuum"
    value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

}

