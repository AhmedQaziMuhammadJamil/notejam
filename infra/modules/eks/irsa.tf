

################################################################################
# IRSA Roles
################################################################################


module "cluster_autoscaler_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                        = "cluster-autoscaler-${var.env}"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_id]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["monitoring:cluster-autoscaler"]
    }
  }
  tags = var.custom_tags
  
}


module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "ebs-csi-${var.env}"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-ebs-csi-driver"]
    }
  }

  tags = var.custom_tags
}

module "efs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "efs-csi-${var.env}"
  attach_efs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
  tags = var.custom_tags
}

 module "vpc_cni_ipv4_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "vpc-cni-ipv4-${var.env}"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-vpc-cni"]
    }
  }

  tags = var.custom_tags
  
}

module "vpc_cni_ipv6_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "vpc-cni-ipv6-${var.env}"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-vpc-cni"]
    }
  }

    tags = var.custom_tags
  
} 

module "node_termination_handler_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "node-termination-handler-${var.env}"
  attach_node_termination_handler_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

    tags = var.custom_tags
  
}


module "load_balancer_controller_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "load-balancer-controller-${var.env}"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["production:aws-load-balancer-controller"]
    }
  }

    tags = var.custom_tags
  
}

module "load_balancer_controller_targetgroup_binding_only_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                                                       = "load-balancer-controller-targetgroup-binding-only-${var.env}"
  attach_load_balancer_controller_targetgroup_binding_only_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["production:aws-load-balancer-controller"]
    }
  }

   tags = var.custom_tags
  
}


module "secrets-manger-role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "ascp-${var.env}"
  attach_external_secrets_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["production:ascp-csi-secrets-store-provider-aws"]

    }
  }

    tags = var.custom_tags
  
}