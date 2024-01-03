#---------------------------------------------
#   Fetch the Secret from 1password
#---------------------------------------------

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


data "onepassword_item" "item" {
  vault = var.vault_id
  uuid  = var.uuid_id
}

# Dummy resource to trigger updates when 1Password data changes
resource "null_resource" "trigger" {
  triggers = {
    note_value_changes = data.onepassword_item.item.note_value
  }
}


locals {
  parsed_secrets = { for entry in regexall("\"(\\w+)\"= \"(\\w+)\"", data.onepassword_item.item.note_value) : entry[0] => entry[1] }
}

resource "github_actions_environment_secret" "env_secrets" {
  repository  = var.github_repository
  environment = var.environment

  for_each = nonsensitive(local.parsed_secrets)

  secret_name     = each.key
  plaintext_value = each.value
}
