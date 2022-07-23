
locals {
  autoscaling_average_cpu = 70
  partition       = data.aws_partition.current.partition
  eks_managed_node_group_defaults = {
    create_launch_template               = true
    create_security_group = false
    vpc_security_group_ids               = [var.worker_sg]
    subnets                              = var.nodegroup_subnets
    create_security_group                = false
    iam_role_additional_policies = [
        # Required by Karpenter
        "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    instance_types                       = ["t3.large"]
    ami_type                             = "AL2_x86_64"
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
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${var.cluster_name}" : "owned",
    }
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = false
    }]

  }
  eks_managed_node_groups = {
    apps = merge(local.eks_managed_node_group_defaults, {
      name = "apps-${var.env}"
      create_security_group = false
      node_security_group_id = [var.worker_sg]
      //subnets                = var.nodegroup_subnets
      max_size               = 6
      min_size               = 1
      desired_size           = 1
      labels = {
        scope = "application" //TODO: ask about labels
      }
       taints = [
        {
          key    = "scope"
          value  = "application"
          effect = "NO_SCHEDULE"
        }
      ] 
    })
    monitoring = merge(local.eks_managed_node_group_defaults, {
       create_security_group = false
    node_security_group_id = [var.worker_sg]
      name                   = "monitoring-${var.env}"
      subnets                = var.nodegroup_subnets
      max_size               = 6
      min_size               = 1
      desired_size           = 1

      labels = {
        scope = "monitoring"
      }
      taints = [
        {
          key    = "scope"
          value  = "monitoring"
          effect = "NO_SCHEDULE"
        }
      ] 
    })
    operations = merge(local.eks_managed_node_group_defaults, {
       create_security_group = false
        node_security_group_id = [var.worker_sg]
      name                   = "operations-${var.env}"
      subnets                = var.nodegroup_subnets
      max_size               = 6
      min_size               = 1
      desired_size           = 1

      labels = {
        scope = "operations"
      }
       taints = [
        {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ] 
    })
      services = merge(local.eks_managed_node_group_defaults, {
      create_security_group = false
       node_security_group_id = [var.worker_sg]
      name                   = "services-${var.env}"
      subnets                = var.nodegroup_subnets
      max_size               = 6
      min_size               = 1
      desired_size           = 1
      target_group_arns      = var.public_target_group_arns

      labels = {
        scope = "services"
      }
      taints = [
        {
          key    = "scope"
          value  = "services"
          effect = "NO_SCHEDULE"
        }
      ] 
    })
  }

  self_managed_node_group_defaults = {
    create_security_group                  = false
    create_launch_template                 = true
    subnet_ids                             = var.nodegroup_subnets
    instance_type                          = "t3a.medium"
    update_launch_template_default_version = true
    platform                               = "windows"
    ami_id                                 = data.aws_ami.win_ami.id
    vpc_security_group_ids                 = [var.worker_sg]
    name                                   = "windows-nodegroup"
    public_ip                              = false
    set_instance_types_on_lt               = true
    capacity_type                          = "ON_DEMAND"
    metadata_http_endpoint                 = "enabled"
    metadata_http_tokens                   = "required"
    metadata_http_put_response_hop_limit   = 2
    key_name                               = var.key_name
    ebs_optimized                          = true
    bootstrap_extra_args = "-KubeletExtraArgs '--node-labels=scope=windows --register-with-taints=os=windows:NoSchedule'"
    block_device_mappings = {
      xvda = {
        device_name = "/dev/sda1"
        ebs = {
          volume_size           = 75
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          encrypted             = true
          kms_key_id            = data.aws_kms_alias.ebs.target_key_arn
          delete_on_termination = true
        }
      }
    }
    create_iam_role              = true
    iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = false
    }]
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${var.cluster_name}" : "owned",
    }

  }




  self_managed_node_groups = {
    windows = merge(local.self_managed_node_group_defaults, {
      max_size     = 6
      min_size     = 1
      desired_size = 1
     

    })

  }















  cluster_version = "1.22"
  name            = "ex-iam-eks-role"
  region          = "eu-west-1"
  coredns = {
    cluster_name      = module.base.cluster_id
    addon_name        = "coredns"
    addon_version     = "v1.8.7-eksbuild.1"
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

    addon_version = "v1.11.2-eksbuild.1"

    resolve_conflicts = "OVERWRITE"
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
    addon_version     = "v1.22.6-eksbuild.1"
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
    cidr_blocks = ["192.168.0.0/16"] //TODO add subnets
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

//TODO:: Add windows nodes,refer staging
