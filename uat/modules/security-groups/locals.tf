locals {
  alb_sg_name    = "${var.alb_sg_name}-${var.env}"
  worker_sg_name = "${var.alb_sg_name}-${var.env}"
  rds_sg_name    = "${var.rds_sg_name}-${var.env}"
} 