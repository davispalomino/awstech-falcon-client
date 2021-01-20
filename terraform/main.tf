provider "aws" {
  version = "~> 2.1"
  region = "us-east-1"
}

terraform {
  backend "s3" {}
}
