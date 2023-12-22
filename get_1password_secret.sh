#!/bin/bash

# 1Password item details
OP_VAULT="my_secret"
OP_ITEM="dev"

# Set your GitHub repository and environment name
github_repo="codora-io/terraform-1password-secret-fetcher"
github_environment="dev"

# Fetch latest values from 1Password
op_data=$(op item get "$OP_ITEM" --vault="$OP_VAULT" --fields=notesPlain)
echo "fetch latest values from 1Password $op_data"

# Extract key-value pairs from the 1Password data
declare -A latest_values
while IFS= read -r line; do
  key=$(echo "$line" | awk -F' =' '{print $1}' | tr -d '[:space:]' | tr -c '[:alnum:]_-' '_')
  value=$(echo "$line" | awk -F' =' '{print $2}' | tr -d '[:space:]' | tr -d '"')
  latest_values["$key"]=$value
done <<< "$op_data"

echo "json latest values from 1Password ${latest_values[@]}"

# Fetch current GitHub secrets
current_github_secrets_raw=$(gh secret list -R $github_repo -e $github_environment --json name)

# Parse the JSON output
current_github_secrets=$(echo "$current_github_secrets_raw" | jq -r '.[]."name"')

echo "Fetch current GitHub secrets: $current_github_secrets"

# Identify GitHub secrets to delete that are not present in 1Password
# Identify GitHub secrets to delete that are not present in 1Password
secrets_to_delete=()
for secret_name in $current_github_secrets; do
  # Trim extra characters or spaces from the GitHub secret name
  trimmed_secret_name=$(echo "$secret_name" | tr -d '[:space:]' | tr -c '[:alnum:]_-' '_')
  if [ -z "$(echo "${latest_values[@]}" | grep -i "$trimmed_secret_name")" ]; then
    secrets_to_delete+=("$secret_name")
  fi
done


echo "GitHub secrets to delete that are not present in 1Password: ${secrets_to_delete[@]}"



# Delete GitHub secrets that are not present in 1Password
for secret_to_delete in "${secrets_to_delete[@]}"; do
  gh secret delete $secret_to_delete -R $github_repo -e "$github_environment"
  echo "GitHub secret '$secret_to_delete' deleted."
done

# Update or add GitHub secrets with values from 1Password
for key in "${!latest_values[@]}"; do
  secret_name="$key"
  if [[ "$current_github_secrets" == *"$secret_name"* ]]; then
    # Secret exists, update its value
    gh secret set $secret_name -R $github_repo -b "${latest_values[$key]}" -e "$github_environment"
    echo "GitHub secret '$secret_name' updated successfully."
  else
    # Secret doesn't exist, add it
    gh secret set $secret_name -R $github_repo -b "${latest_values[$key]}" -e "$github_environment"
    echo "GitHub secret '$secret_name' added successfully."
  fi
done
