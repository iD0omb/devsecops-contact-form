# Declare what is needed
terraform {
  required_version = ">=1.5" # Minimum required version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Required version range 6.x
    }
  }
}