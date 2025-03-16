terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "environment" = "dev"
      "owner"       = "RianPeters"
    }
  }
}

provider "random" {}

provider "archive" {}