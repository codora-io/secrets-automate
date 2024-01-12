# Terraform Module for 1Password to GitHub Secrets Integration
This Terraform module automates the process of fetching secrets from a specified 1Password vault and storing them as GitHub Secrets within a specified repository environment.

# How It Works
## Password Secrets Retrieval and GitHub Secrets Integration:

1. The module retrieves secrets from a specified 1Password vault using the 1Password Terraform provider.
2. It then automatically adds these secrets as GitHub Secrets for a specified repository and environment using the GitHub Terraform provider.

## Vault and Credentials Identification:

1. Specify the name or use the op command to dynamically fetch the 1Password vault ID (vault_id).
2. Use the op command to dynamically fetch the items' UUIDs (credentials_id) you want to retrieve from the specified vault.

# GitHub Repository and Environment Configuration:

Specify the GitHub repository (repository) and the target environment (environment) where the secrets should be added as GitHub Secrets.
## Usage:

Include the module in your Terraform configuration, providing the necessary input variables.
## Output:

The module captures and returns the retrieved secrets from 1Password.

## setup 1password cli & OP Command to get the vault and uuid id

```shell
sudo apt-get update
sudo apt-get install -y unzip
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo apt update && sudo apt install 1password-cli
op --version


# to get the id of vault
op vault list
# for item uuid
op item list

```

## To setup the Service account in 1password
https://developer.1password.com/docs/secrets-automation/#1password-service-accounts

Commands
Terraform Plan, Validate, Apply
# Use Prefix AWS_PROFILE=terraform-development if facing profile issues.
terraform init
terraform fmt --check --recursive -diff
terraform validate
terraform plan
terraform destroy
Terraform States List, Destroy
terraform state list
terraform destroy -target=RESOURCE_TYPE.NAME
Terraform Lock States
 terraform force-unlock -force <lock-id>
# OR 
ps aux | grep terraform & sudo kill -9 <process_id>