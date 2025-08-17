


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.9.0"
    }
  }
    backend "s3" {
    bucket         = "terraformprojectbackend"
    region         = "us-east-1"
    key            = "eks/terraform.tfstate"
  }


}

provider "aws" {
  region  = var.aws-region
}