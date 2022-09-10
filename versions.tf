terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.1.9"
}

provider "aws" {
  alias  = "cloud"
  region = var.region
}
