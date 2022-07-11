
locals {
  autoscaling_average_cpu = 70
  eks_managed_node_group_defaults = {
    create_launch_template               = true
    subnets                              = var.nodegroup_subnets
    instance_types                       = ["c7g.medium"]
    ami_type                             = "AL2_ARM_64"
    set_instance_types_on_lt             = true
    capacity_type                        = "ON_DEMAND"
    metadata_http_endpoint               = "enabled"
    metadata_http_tokens                 = "required"
    metadata_http_put_response_hop_limit = 2
    ebs_optimized                        = true
    disk_type                            = "gp3"
    disk_size                            = 50
    disk_encrypted                       = true
    disk_kms_key_id                      = data.aws_kms_alias.ebs.target_key_arn
    create_iam_role                      = true
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = false
    }]

  }
  eks_managed_node_groups = {
    apps = merge(local.eks_managed_node_group_defaults, {
      name                   = "apps-${var.env}"
      //subnets                = var.nodegroup_subnets
      max_size           = 6
      min_size           = 3
      desired_size       = 3
      node_security_group_id = [var.worker_sg]
      k8s_labels = {
        scope = "apps"
      }
      /*       taints = [
        {
          key    = "scope"
          value  = "apps"
          effect = "NO_SCHEDULE"
        }
      ] */
    })
    monitoring = merge(local.eks_managed_node_group_defaults, {
      name                   = "monitoring-${var.env}"
      node_security_group_id = [var.worker_sg]
      subnets                = var.nodegroup_subnets
      max_size           = 6
      min_size           = 3
      desired_size       = 3

      k8s_labels = {
        scope = "monitoring"
      }
      /* taints = [
        {
          key    = "scope"
          value  = "monitoring"
          effect = "NO_SCHEDULE"
        }
      ] */
    })
    operations = merge(local.eks_managed_node_group_defaults, {
      name                   = "operations-${var.env}"
      node_security_group_id = [var.worker_sg]
      subnets                = var.nodegroup_subnets
      max_size           = 6
      min_size           = 3
      desired_size       = 3

      k8s_labels = {
        scope = "operations"
      }
      /*        taints = [
        {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ]  */
    })
  }

  cluster_version = "1.22"
  name            = "ex-iam-eks-role"
  region          = "eu-west-1"
  coredns = {
    cluster_name      = module.base.cluster_id
    addon_name        = "coredns"
    addon_version     = "v1.8.4-eksbuild.1"
    resolve_conflicts = "OVERWRITE"

    tags = merge(
      var.common_tags,
      {
        "eks_addon" = "coredns"
      }
    )
  }
  vpc-cni = {
    cluster_name = module.base.cluster_id
    addon_name   = "vpc-cni"

    addon_version = "v1.10.2-eksbuild.1"

    resolve_conflicts        = "OVERWRITE"
    tags = merge(
      var.common_tags,
      {
        "eks_addon" = "vpc-cni"
      }
    )
  }
  kube-proxy = {
    cluster_name      = module.base.cluster_id
    addon_name        = "kube-proxy"
    addon_version     = "v1.21.2-eksbuild.2"
    resolve_conflicts = "OVERWRITE"

    tags = merge(
      var.common_tags,
      {
        "eks_addon" = "kube-proxy"
      }
    )
  }
  admin_access = {
    description = "Admin ingress to Kubernetes API"
    cidr_blocks = ["10.10.0.0/16"] //TODO add subnets
    protocol    = "all"
    from_port   = 0
    to_port     = 65535
    type        = "ingress"
  }
  node_egress = {
    description = "EgressTraffic"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "all"
    from_port   = 0
    to_port     = 65535
    type        = "egress"
  }
  ingress_all_node = {
    description = "Node to node traffic open"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    type        = "ingress"
    self        = true
  }

}