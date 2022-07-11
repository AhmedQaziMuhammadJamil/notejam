
data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
}


module "base" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "~> 18.26.3"
  cluster_name                    = var.cluster_name
  eks_managed_node_groups         = local.eks_managed_node_groups
  eks_managed_node_group_defaults = local.eks_managed_node_group_defaults
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  subnet_ids                      = var.control_plane_subnet_ids
  control_plane_subnet_ids        =  var.nodegroup_subnets
  vpc_id                          = var.vpc_id
  
  
  
  create_kms_key                  = true
  cluster_encryption_config = [{
    resources        = ["secrets"]
  }] 
  kms_key_deletion_window_in_days = 7
  enable_kms_key_rotation         = true


  



  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  cluster_addons = {
    kube-proxy = "${local.kube-proxy}"
    vpc-cni    = "${local.vpc-cni}"
    coredns    = "${local.coredns}"
  }

  cluster_security_group_additional_rules = {
    admin_access     = "${local.admin_access}"
    node_egress      = "${local.node_egress}"
    ingress_all_node = "${local.ingress_all_node}"
  }




  node_security_group_additional_rules = {
    # https://github.com/kubernetes-sikeygs/aws-load-balancer-controller/issues/2039#issuecomment-1099032289
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
    }
    # allow connections from ALB security group
    ingress_allow_access_from_alb_sg = {
      type                     = "ingress"
      protocol                 = "-1"
      from_port                = 0
      to_port                  = 0
      source_security_group_id = var.alb_sg
    }
    # allow connections from EKS to the internet
    egress_all = {
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    # allow connections from EKS to EKS (internal calls)
    ingress_self_all = {
      protocol  = "-1"
      from_port = 0
      to_port   = 0
      type      = "ingress"
      self      = true
    }
  }



  tags                            = var.common_tags
}


# set spot fleet Autoscaling policy
resource "aws_autoscaling_policy" "eks_autoscaling_policy" {
  count = length(local.eks_managed_node_groups)

  name                   = "${module.base.eks_managed_node_groups_autoscaling_group_names[count.index]}-autoscaling-policy"
  autoscaling_group_name = module.base.eks_managed_node_groups_autoscaling_group_names[count.index]
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = local.autoscaling_average_cpu
  }
}