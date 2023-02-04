terraform {
  required_version = ">= 1.3.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.53.0"
    }
  }

  backend "s3" {
  }
}

provider "aws" {
  region = var.region
}

module "cloudwatch-exporter" {
  source = "./cloudwatch-exporter"

  bucket_name   = var.bucket_name
  function_name = var.function_name
  role_name     = var.role_name
}
