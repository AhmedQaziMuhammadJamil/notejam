module "pgsql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.5.0"

  identifier = "easygenerator-${local.common_tags.environment}-pgsql"

  engine               = "postgres"
  engine_version       = "13.4"
  family               = "postgres13"
  major_engine_version = "13"
  instance_class       = "db.t3.small"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true

  username = "ezgen"
  password = var.pg_password
  port     = 5432

  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [aws_security_group.pgsql_sg.id]

  maintenance_window      = "Mon:22:00-Mon:23:00"
  backup_window           = "23:00-02:00"
  backup_retention_period = 30
  skip_final_snapshot     = false
  deletion_protection     = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "easygenerator-${local.common_tags.environment}-pgsql-monitoring-role"

  auto_minor_version_upgrade = true
  apply_immediately          = false

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = merge(
    local.common_tags,
    {
      "Name" = "easygenerator-${local.common_tags.environment}-pgsql"
  })
}