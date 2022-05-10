resource "aws_db_parameter_group" "db-pg" {
  name        = "notejam-pg-${var.env}"
  family      = var.pgfamily
  description = "Parameter group for notejam -${var.env}"
  tags = var.custom_tags
}

resource "aws_rds_cluster_parameter_group" "cpg" {
  name        = "notejam-cluster-pg-${var.env}"
  family      = var.pgfamily
  description = "Cluster Parameter group for notejam -${var.env}"
  tags = var.custom_tags
}

locals {
  db_user={
    POSTGRES_USER=var.db_user
  }
  db_pass={
    POSTGRES_PASS=var.db_pass
  }
  db_name= {
    POSTGRES_DB=var.db_name
  }
  db_host={
    POSTGRES_URL=module.rds-aurora.cluster_endpoint
  }
}
resource "aws_secretsmanager_secret" "rds-user" {
  name = "notejam-db-master-username-${var.env}"
  recovery_window_in_days = 0
}

 resource "aws_secretsmanager_secret_version" "secret-username" {
  secret_id     = aws_secretsmanager_secret.rds-user.id
  secret_string = jsonencode(local.db_user)
} 


resource "aws_secretsmanager_secret" "rds-password" {
  name = "notejam-db-master-password-${var.env}"
   recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret-password" {
  secret_id     = aws_secretsmanager_secret.rds-password.id
  secret_string = jsonencode(local.db_pass)
  
}

resource "aws_secretsmanager_secret" "rds-db-name" {
  name = "notejam-db-name-${var.env}"
   recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret-name" {
  secret_id     = aws_secretsmanager_secret.rds-db-name.id
  secret_string = jsonencode(local.db_name)
}

resource "aws_secretsmanager_secret" "rds-db-host" {
  name = "notejam-db-host-${var.env}"
   recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret-host" {
  secret_id     = aws_secretsmanager_secret.rds-db-host.id
  secret_string = jsonencode(local.db_host)
}


module "rds-aurora" {
  source                 = "terraform-aws-modules/rds-aurora/aws"
  version                = "6.2.0"
  create_db_subnet_group = true
  create_security_group  = false
  create_random_password = false
  name                   = "notejam-db-${var.env}"
  engine                 = "aurora-postgresql"
  engine_version         = "11.13"
  instance_class         = "db.t3.medium"
  master_password        = var.db_pass
  master_username        = var.db_user
  database_name          = var.db_name     
  instances = {
    writer = {
      instance_class = "db.t3.medium"
    }
    
     reader = {
      instance_class = "db.t3.medium"
    } 

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

