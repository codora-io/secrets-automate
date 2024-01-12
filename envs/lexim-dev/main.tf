terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
    onepassword = {
      source  = "1password/onepassword"
      version = "~> 1.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "1password-terraform"
}

# add the service account token of 1password
provider "onepassword" {
  service_account_token = var.service_account_token_1pass
}