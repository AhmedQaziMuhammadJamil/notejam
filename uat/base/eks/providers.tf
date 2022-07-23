terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
   github = {
      source = "integrations/github"
      version = "4.27.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.12.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }

      flux = {
      source = "fluxcd/flux"
      version = "0.15.3"
    }
  }
}


 