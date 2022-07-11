terraform {
  required_version = ">= 1.2.2"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Easygenerator"

    workspaces {
      name = "uat"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.21.0"

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
      Enviornment = var.env
      Managed-By  = "Terraform"

    }
  }
}
