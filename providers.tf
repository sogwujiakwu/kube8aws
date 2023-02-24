terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.9.0"
    }
  }
   backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "tfstate-bucket-20230224"
  }
}

provider "aws" {
  region	= var.AWS_REGION
}
