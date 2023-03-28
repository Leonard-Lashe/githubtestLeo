terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region       = "us-west-2"
    access_key = "AKIA5S6WSJQSNUZBYA5W"
  secret_key   = "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"
   arn         = "arn:aws:iam::aws:policy/AdministratorAccess"
}

