locals {
  alb_sg_name      = "${var.alb_sg_name}-${var.env}"
  worker_sg_name   = "${var.alb_sg_name}-${var.env}"
  rds_sg_name      = "${var.rds_sg_name}-${var.env}"
  redis_sg_name    = "${var.redis_sg_name}-${var.env}"
  rabbitmq_sg_name = "${var.rabbitmq_sg_name}-${var.env}"
  efs_sg_name      = "${var.efs_sg_name}-${var.env}"
  documentdb_sg_name = "${var.documentdb_sg_name}-${var.env}"
  
} 