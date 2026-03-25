terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "~> 8.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.32"
    }
  }
}

provider "aviatrix" {
  # Credentials should be set via environment variables:
  # AVIATRIX_CONTROLLER_IP
  # AVIATRIX_USERNAME
  # AVIATRIX_PASSWORD
}

provider "aws" {
  region = var.aws_region
  # Credentials should be set via environment variables or AWS CLI profile
}
