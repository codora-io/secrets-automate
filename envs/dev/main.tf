terraform {
  required_providers {
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 1.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "onepassword" {
  service_account_token = var.service_account_token_1pass
}

provider "github" {
  token = var.gh_token

}

module "fetch&put_secret" {
  source            = "../../modules/secret_fetch"
  vault_id          = var.vault_id
  uuid_id           = var.uuid_id
  github_repository = var.gh_repository
  environment       = var.environment

}