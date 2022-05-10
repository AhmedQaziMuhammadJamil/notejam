terraform {
  required_version = ">= 1.1.3"

  cloud {
    hostname     = "app.terraform.io"
    organization = "Alpha-Project"

    workspaces {
      name = "notejam-prod"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.74.2"
    }

    kubernetes = {
      source  = "registry.terraform.io/hashicorp/kubernetes"
      version = ">=2.9.0"
    }
   kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.13.3"
    }
     null = {
      source = "hashicorp/null"
      version = "3.1.1"
    }
  }
  }
provider "aws" {
  region = var.var_region
}

