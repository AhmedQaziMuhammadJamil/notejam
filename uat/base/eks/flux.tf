####Flux
locals {
  repo_name = lower("${var.flux_repository_name}-${var.env}")

}
provider "kubectl" {
  apply_retry_count      = 10
  host                   =  data.aws_eks_cluster.default.endpoint
  token                  = data.aws_eks_cluster_auth.default.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  load_config_file       = false
}

/* provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}
 */
##FLUX

provider "github" {
  owner = var.flux_github_owner
  token = var.flux_github_token
}

data "flux_install" "main" {
  target_path      = var.target_path
  components_extra = var.components_extra
  network_policy   = false
  toleration_keys  = [{
      "key": "scope"
      "operator": "Equal"
      "value": "services"
      "effect": "NoSchedule"
}]

}


###Deleting resouces in k8s as provider doesn't provide any idempotentancy

# Kubernetes
resource "kubernetes_namespace" "flux_system" {

  metadata {
    name = "flux-system"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels
    ]
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



  #TODO: uncomment for sync
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  url = "https://git@github.com/${var.flux_github_owner}/${local.repo_name}.git"
  //flux_sync_yaml_documents_without_namespace = [for x in local.sync: x if x.data.kind != "Namespace"]

  ecr-patch = {
    patches = <<EOT
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- gotk-sync.yaml
- gotk-components.yaml
patches:
  - target:
      version: v1
      group: apps
      kind: Deployment
      name: image-reflector-controller
      namespace: flux-system
    patch: |-
      - op: add
        path: /spec/template/spec/containers/0/args/-
        value: --aws-autologin-for-ecr
  - target:
      version: v1
      group: apps
      kind: Deployment
      name: source-controller
      namespace: flux-system
    patch: |-
      - op: replace
        path: /spec/template/spec/containers/0/resources/limits/memory
        value: 1500Mi
EOT
  }


}


resource "kubectl_manifest" "apply" {

  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}



resource "kubectl_manifest" "sync" {

  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value

}

####Flux+GitHub 8-04-2022



resource "github_repository" "main" {
  name       = local.repo_name
  visibility = var.flux_repository_visibility
  auto_init  = true
}

resource "github_branch_default" "main" {
  repository = github_repository.main.name
  branch     = var.flux_branch
}


resource "github_repository_file" "install" {
  repository = github_repository.main.name
  file       = data.flux_install.main.path
  content    = data.flux_install.main.content
  branch     = var.flux_branch
}



data "flux_sync" "main" {
  target_path        = var.target_path
  url                = local.url
  branch             = var.flux_branch
  git_implementation = "go-git"
  name               = "${var.env}-source"
  secret             = "flux-system"
  namespace          = "flux-system"
  //patch_names  = keys(local.ecr-patch)
}

output "gitrepo" {
  value = data.flux_sync.main
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.apply]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    username = "git"
    password = var.flux_github_token
  }
}


resource "github_repository_file" "sync" {
  repository = github_repository.main.name
  file       = data.flux_sync.main.path
  content    = data.flux_sync.main.content
  branch     = var.flux_branch

}

resource "github_repository_file" "kustomize" {
  repository          = github_repository.main.name
  file                = data.flux_sync.main.kustomize_path
  content             = local.ecr-patch["patches"]
  branch              = var.flux_branch
  overwrite_on_create = true
}


