  terraform {
  required_version = ">= 1.1.9"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
     github = {
      source  = "integrations/github"
      version = ">= 4.5.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">=3.1.0"
    }
    
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }

    flux = {
      source  = "fluxcd/flux"
      version = "0.14.1"
    }
  }
}


 