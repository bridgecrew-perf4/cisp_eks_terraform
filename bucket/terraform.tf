provider "aws" {
  region = "sa-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "cisp-tf-state"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  
  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_dynamodb_table" "terraform_lock" {
  name         = "cisp-tf-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}


