terraform {
  required_providers {
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
# add the service account token of 1password
provider "onepassword" {
  service_account_token = var.service_account_token_1pass
}
# add the github token for putting the secret into github secret
provider "github" {
  token = var.gh_token
}

module "fetch_secret" {
  source            = "../../modules/secret_fetch"
  vault_id          = var.vault_id
  uuid_id           = var.uuid_id
  github_repository = var.gh_repository
  environment       = var.environment
}
