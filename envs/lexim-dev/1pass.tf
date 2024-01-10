module "fetch_secret" {
  source            = "../../modules/secret_fetch"
  vault_id          = var.vault_id
  uuid_id           = var.uuid_id
  github_repository = var.gh_repository
  environment       = var.environment
}
