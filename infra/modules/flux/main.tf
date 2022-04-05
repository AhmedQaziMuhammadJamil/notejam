/* provider "flux" {}

provider "kubectl" {}


provider "kubernetes" {
  alias = "eks"
  host                   = data.aws_eks_cluster.target.endpoint
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
 
}




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

resource "kubectl_manifest" "install" {

  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
} */