terraform {
  required_version = ">= 1.2.2"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Alpha-Project"

    workspaces {
      name = "uat"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.21.0"

    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.12.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.19.0"
    }
    github = {
      source = "integrations/github"
      version = "4.27.1"
    }

    tfe = {
      source = "hashicorp/tfe"
    }

  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.env
      Managed-By  = "Terraform"

    }
  }
}

