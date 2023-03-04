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

  bucket     = var.bucket
  log_group  = var.log_group
  function   = var.function
  role       = var.role
  event_rule = var.event_rule
}
