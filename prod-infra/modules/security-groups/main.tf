resource "aws_security_group" "alb" {
  lifecycle {
    ignore_changes = [ingress]
  }
  for_each = var.alb-sg
  name     = local.alb_sg_name
  vpc_id   = var.vpc_id
  dynamic "ingress" {
    for_each = each.value.rules
    content {
      to_port     = ingress.value.to_port
      from_port   = ingress.value.from_port
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
      protocol    = ingress.value.protocol
    }


  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.custom_tags, { Name = local.alb_sg_name })

}


resource "aws_security_group" "worker-node" {
  lifecycle {
    ignore_changes = [ingress]
  }
  for_each = var.worker-node-sg
  name     = local.worker_sg_name
  vpc_id   = var.vpc_id
  dynamic "ingress" {
    for_each = each.value.rules
    content {
      to_port         = ingress.value.to_port
      from_port       = ingress.value.from_port
      description     = ingress.value.description
      security_groups = ["${aws_security_group.alb["NoteJam-Alb-SG"].id}"]
      protocol        = ingress.value.protocol

    }

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = merge(var.custom_tags, { Name = local.worker_sg_name })

}


resource "aws_security_group" "rds" {
  lifecycle {
    ignore_changes = [ingress]
  }
  for_each = var.rds-sg
  name     = local.rds_sg_name
  vpc_id   = var.vpc_id
  dynamic "ingress" {
    for_each = each.value.rules
    content {
      to_port         = ingress.value.to_port
      from_port       = ingress.value.from_port
      description     = ingress.value.description
      security_groups = ["${aws_security_group.worker-node["NoteJam-Worker-SG"].id}"]
      protocol        = ingress.value.protocol
    }

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.custom_tags, { Name = local.rds_sg_name })

}

  