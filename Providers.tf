terraform {
  required_providers {
    aws = {
      source  = "aws"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
}

