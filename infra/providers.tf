terraform {
  required_version = ">= 1.1.3"

  cloud {
    hostname     = "app.terraform.io"
    organization = "Alpha-Project"

    workspaces {
      name = "notejam"
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
      version = ">= 1.10.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.12.2"
    }
  }
  }
provider "aws" {
  region = "eu-west-1"
}