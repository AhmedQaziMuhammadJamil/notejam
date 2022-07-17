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

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.19.0"
    }
    github = {
      source = "integrations/github"
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

