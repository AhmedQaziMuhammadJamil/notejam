terraform {
  required_version = ">= 1.1.3"

  cloud {
    hostname     = "app.terraform.io"
    organization = "Alpha-Project"

    workspaces {
      name = "notejam-dev"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.14.1"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.1.1"
    }
  }
}
provider "aws" {
  region = var.var_region
}

