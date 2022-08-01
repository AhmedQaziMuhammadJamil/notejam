locals {
  k8s_cluster_autoscaler_sa_namespace = "kube-system"
  k8s_cluster_autoscaler_sa_name      = "autoscaler-aws-cluster-autoscaler-chart"
  k8s_vault_kms_unseal_sa_namespace   = "vault"
  k8s_vault_kms_unseal_sa_name        = "vault"
}



/* module "cluster_autoscaler_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_id]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }

  tags = local.tags
}
 */

module "eks_external_dns_iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 4.22.0"

  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/*"]

  oidc_providers = {
    ex = {
      provider_arn               = module.base.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}



module "vault_kms_unseal_oidc" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "easygenerator-${var.env}-vault-kms-unseal"
  provider_url                  = module.base.cluster_oidc_issuer_url
  role_policy_arns              = [aws_iam_policy.vault_kms_unseal.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_vault_kms_unseal_sa_namespace}:${local.k8s_vault_kms_unseal_sa_name}"]

  tags = merge(
    var.common_tags,
    {
      "Name" = "easygenerator-${var.env}-vault-kms-unseal"
  })
}

resource "aws_iam_policy" "vault_kms_unseal" {
  name_prefix = "easygenerator-${var.env}-vault-kms-unseal"
  description = "easygenerator-${var.env}-vault-kms-unseal"
  policy      = data.aws_iam_policy_document.vault_kms_unseal.json
}

data "aws_iam_policy_document" "vault_kms_unseal" {
  statement {
    sid       = "VaultKMSUnseal"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
  }
}


module "efs_csi_irsa_role" {
   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
   version = "~> 4.22.0"

  role_name             = "efs-csi"
  attach_efs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.base.oidc_provider_arn
      namespace_service_accounts = ["efs-csi:efs-csi-controller-sa"]
    }
  }


  tags = merge(
    var.common_tags,
    {
      "Name" = "easygenerator-${var.env}-efs-csi"
  })
}

module "cluster_autoscaler_irsa_role" {
   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
   version = "~> 4.22.0"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.base.cluster_id]

  oidc_providers = {
    ex = {
      provider_arn               = module.base.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }

tags = merge(
    var.common_tags,
    {
      "Name" = "easygenerator-${var.env}-cluster-autoscaler"
  })

}