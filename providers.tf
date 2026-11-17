# Provider Plugin
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
}


# Standard Region
provider "aws" {
  region = "eu-central-1" # Frankfurt
}
