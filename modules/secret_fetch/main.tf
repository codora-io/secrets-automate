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

# using data source for fetching the data from 1password
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

# filter the read data for putting into github secrets
locals {
  parsed_secrets = regexall("\"?(\\w+)\"?\\s*=\\s*\"([^\"]+)\"", data.onepassword_item.item.note_value)
  secrets_map    = { for entry in local.parsed_secrets : replace(entry[0], "\"", "") => entry[1] }
}

output "all_values" {
  value     = local.secrets_map
  sensitive = true
}

#setting up resource to put data into environment of github secret
resource "github_actions_environment_secret" "env_secrets" {
 repository  = replace(var.github_repository, "/", "-")
  environment = var.environment

  for_each = nonsensitive(local.secrets_map)

  secret_name     = each.key
  plaintext_value = each.value
}

