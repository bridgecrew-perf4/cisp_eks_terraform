provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "cisp-tf-state"
    key            = "global/s3/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "cisp-tf-lock-table"
    encrypt        = true
  }
}

