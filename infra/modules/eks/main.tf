data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
}

locals {
  eks_managed_node_group_defaults = {
    create_launch_template               = true
    subnets                              = var.private_subnets
    instance_types                       = ["t3a.medium"]
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
     
  }
  node_groups = {
    apps = merge(local.eks_managed_node_group_defaults, {
      name_prefix = "apps"

      instance_types   = ["m5a.large"]
      max_capacity     = 3
      min_capacity     = 3
      desired_capacity = 3

      k8s_labels = {
        scope = "apps"
      }
      taints = [
        {
          key    = "scope"
          value  = "apps"
          effect = "NO_SCHEDULE"
        }
      ]
    })
    monitoring = merge(local.eks_managed_node_group_defaults, {
      name_prefix = "monitoring"

      max_capacity     = 1
      min_capacity     = 1
      desired_capacity = 1

      k8s_labels = {
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
      name_prefix = "operations"

      max_capacity     = 2
      min_capacity     = 2
      desired_capacity = 2

      k8s_labels = {
        scope = "operations"
      }
      /* taints = [
        {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ] */
    })

  }

  cluster_name="notejam"
  cluster_version = "1.21"
  coredns = {
    cluster_name      = module.eks.cluster_id
    addon_name        = "coredns"
    addon_version     = "v1.8.4-eksbuild.1"
    resolve_conflicts = "OVERWRITE"

    tags = merge(
      var.custom_tags,
      {
        "eks_addon" = "coredns"
      }
    )
  }
  vpc-cni = {
    cluster_name      = module.eks.cluster_id
    addon_name        = "vpc-cni"

    addon_version     = "v1.10.2-eksbuild.1"

    resolve_conflicts = "OVERWRITE"
    service_account_role_arn = module.vpc_cni_irsa.iam_role_arn

    tags = merge(
      var.custom_tags,
      {
        "eks_addon" = "vpc-cni"
      }
    )
  }
  kube-proxy = {
    cluster_name      = module.eks.cluster_id
    addon_name        = "kube-proxy"
    addon_version     = "v1.21.2-eksbuild.2"
    resolve_conflicts = "OVERWRITE"

    tags = merge(
      var.custom_tags,
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

}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.17.0"
  cluster_name                    = local.cluster_name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true

  cluster_endpoint_public_access  = true //TODO: Make it public

  create_cni_ipv6_iam_policy = true
  enable_irsa = true
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
    cluster_encryption_config = [{
    provider_key_arn = var.cluster_kms
    resources        = ["secrets"]
  }]
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets
  eks_managed_node_group_defaults = {
    create_node_security_group = false
    vpc_security_group_ids = [var.worker-sg]
    ami_type               = "AL2_x86_64"
    create_iam_role = true
    iam_role_use_name_prefix = true
  }

  eks_managed_node_groups            = local.node_groups
  create_cluster_security_group = true
  cluster_security_group_use_name_prefix = true 
  create_iam_role = true
  iam_role_use_name_prefix = false
  cluster_security_group_additional_rules = {
   admin_access = "${local.admin_access}"
   node_egress  = "${local.node_egress}"
  }  
}


module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "vpc_cni"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = var.custom_tags

}
##ALB


/* data "aws_region" "current" {}

data "aws_eks_cluster" "target" {
  name = local.cluster_name

  depends_on = [
    module.eks
  ]

}

data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.aws_eks_cluster.target.name

    depends_on = [
    module.eks
  ]

}

provider "kubernetes" {
  alias = "eks"
  host                   = data.aws_eks_cluster.target.endpoint
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
 
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.aws_eks_cluster.target.endpoint
    token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  }
} 
 module "alb_controller" {
  source  = "iplabs/alb-ingress-controller/kubernetes"
  version = "3.4.0"

    depends_on = [
    module.eks
    ]

  providers = {
    kubernetes = "kubernetes.eks",
    helm       = "helm.eks"
  }

  k8s_cluster_type = "eks"
  k8s_namespace    = "kube-system"

  aws_region_name  = data.aws_region.current.name
  k8s_cluster_name = data.aws_eks_cluster.target.name
  } 

 */
##################INGRESSS

#Get EKS Cluster ID 
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
   depends_on = [module.eks]
}

#Get EKS Cluister ID for Authentication
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
   depends_on = [module.eks]
}

data "tls_certificate" "tls_cluster" {
  url = module.eks.cluster_oidc_issuer_url
   depends_on = [module.eks]
  #url = aws_eks_cluster.example.identity[0].oidc[0].issuer
}



provider "helm" {
   alias = "eks"
  kubernetes {
     depends_on = [module.eks]
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}

provider "kubernetes" {
   depends_on = [module.eks]
  alias = "eks"
  host                   = data.aws_eks_cluster.target.endpoint
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
 
}


data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.aws_eks_cluster.target.name

    depends_on = [
    module.eks
  ]

}

data "aws_region" "current" {}

data "aws_eks_cluster" "target" {
  name = local.cluster_name

  depends_on = [
    module.eks
  ]

}
module "eks-lb-controller" {

  source  = "DNXLabs/eks-lb-controller/aws"
  version = "0.5.1"
  # insert the 4 required variables here
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  cluster_name                     = module.eks.cluster_id
  depends_on = [module.eks]

}
