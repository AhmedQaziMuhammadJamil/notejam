resource "aws_lb" "alb_ingress" {
  name                       = "alb-ingress-notejam"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false

  idle_timeout = "120"

  subnets = var.public_subnets

  tags = merge(var.custom_tags,{app="ingress"})
    
  security_groups = [var.alb-sg]
}

# Create a target group to forward traffic to nginx-ingress port
resource "aws_alb_target_group" "nginx-ingress" {
  name     = "nginx-ingress"
  port     = 32080 # TODO: Hadrdcoded align with kubernetes/nginx-ingress/values.yaml: nodeport
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled = true
    matcher = "200-499"
  }
}


resource "aws_lb_listener" "http_ingress" {
  load_balancer_arn = aws_lb.alb_ingress.arn
  port              = "80"
  protocol          = "HTTP"
default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.nginx-ingress.arn
  }
}

output "ingress_alb" {
  value = aws_lb.alb_ingress.dns_name
}


# TODO: Use oidc from production and irsa