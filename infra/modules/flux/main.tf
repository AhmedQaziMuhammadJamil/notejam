terraform {
  required_version = ">= 1.1.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.12.2"
    }
  }
}

provider "flux" {}

provider "kubectl" {}

/* provider "kubernetes" {
  config_path = module.mod_flux.config
} */

/* data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
} */
provider "kubernetes" {
  alias = "eks"
  host                   =  var.host  //
  cluster_ca_certificate = var.cluster_ca_certificate //base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  =   var.token   //data.aws_eks_cluster_auth.cluster.token
}
# Flux
data "flux_install" "main" {
  target_path      = var.target_path
  components_extra = var.components_extra
}

# Kubernetes
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}