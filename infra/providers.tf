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
         source = "hashicorp/aws"
         version = "= 3.74.2"
        }
    }
}
  provider "aws" {
  region = "eu-west-1"
}