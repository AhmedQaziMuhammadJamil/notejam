locals {
  alb_sg_name = "${var.alb-sg-name}-${var.env}"
  worker_sg_name = "${var.worker-sg-name}-${var.env}"
  rds_sg_name = "${var.rds-sg-name}-${var.env}"
} 