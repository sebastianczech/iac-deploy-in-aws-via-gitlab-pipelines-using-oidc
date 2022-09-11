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
  assume_role {
    duration_seconds = 3600
    session_name = "gitlab-aws-session"
    role_arn = "arn:aws:iam::884522662008:role/GitlabPipelineAwsOIDCRole"
  }
}
