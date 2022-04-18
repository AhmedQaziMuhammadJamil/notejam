####Flux
provider "kubectl" {
  host                   = var.host
  token                  = var.token
  cluster_ca_certificate = var.cluster_ca_certificate
  load_config_file       = false
}

provider "kubernetes" {
 host                   = var.host
  token                  = var.token
  cluster_ca_certificate = var.cluster_ca_certificate
}


##FLUX

provider "github" {
  owner = var.github_owner
  token = var.github_token
}

# SSH
/* locals {
  known_hosts = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
} */

/* resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}
 */
data "flux_install" "main" {
   /*  depends_on = [module.eks] */
  target_path      = var.target_path
  components_extra = var.components_extra
  network_policy = false

}


###Deleting resouces in k8s as provider doesn't provide any idempotentancy

# Kubernetes
resource "kubernetes_namespace" "flux_system" {
/*   depends_on = [
    module.eks
  ] */
  metadata {
    name = "flux-system"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels
    ]
  }

   provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command = "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl"
  }
    provisioner "local-exec" {
    when       = destroy
    command    = "kubectl patch customresourcedefinition helmcharts.source.toolkit.fluxcd.io helmreleases.helm.toolkit.fluxcd.io helmrepositories.source.toolkit.fluxcd.io kustomizations.kustomize.toolkit.fluxcd.io gitrepositories.source.toolkit.fluxcd.io -p '{\"metadata\":{\"finalizers\":null}}'"
    on_failure = continue
  }

  
 
}


resource "kubernetes_namespace" "monitoring" {
/*   depends_on = [
    module.eks
  ] */
  metadata {
    name = "monitoring"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels
    ]
  }
}

resource "kubernetes_namespace" "operations" {
/*   depends_on = [
    module.eks
  ] */
  metadata {
    name = "production"
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
  url ="https://git@github.com/${var.github_owner}/${var.repository_name}.git"
}


resource "kubectl_manifest" "apply" {

  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body = each.value
}



resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body = each.value
}

####Flux+GitHub 8-04-2022

 

resource "github_repository" "main" {
  name       = var.repository_name
  visibility = var.repository_visibility
  auto_init  = true
}

resource "github_branch_default" "main" {
  repository = github_repository.main.name
  branch     = var.branch
}


resource "github_repository_file" "install" {
  repository = github_repository.main.name
  file       = data.flux_install.main.path
  content    = data.flux_install.main.content
  branch     = var.branch
}


  
data "flux_sync" "main" {
  target_path = var.target_path
  url         = local.url
  branch      = var.branch
   git_implementation = "go-git"
  name = "test-source"
  secret = "flux-system"
  namespace = "flux-system" 
  
}

output "gitrepo" {
  value= "${data.flux_sync.main}"
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
     username="git"
    password=var.github_token 
  }
} 


resource "github_repository_file" "sync" {
  repository = github_repository.main.name
  file       = data.flux_sync.main.path
  content    = data.flux_sync.main.content
  branch     = var.branch

}

resource "github_repository_file" "kustomize" {
  repository = github_repository.main.name
  file       = data.flux_sync.main.kustomize_path
  content    = data.flux_sync.main.kustomize_content
  branch     = var.branch
}

