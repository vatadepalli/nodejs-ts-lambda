terraform {
  required_providers {
    aws = {
      version = "~> 4.11.0"
    }
  }

  backend "s3" {
    bucket = "cloudzsh-playground-terraform-state"
    key    = "terraform-nodejs-ts-serverless-template.state"
    region = "ap-south-1"
  }

  required_version = "~> 1.0"
}

locals {
  lambda_archive_file_path = "${path.module}/function.zip"
}

provider "aws" {
  region = var.aws_region
}

