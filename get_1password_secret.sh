#!/bin/bash
# 1Password item details
OP_VAULT="my_secret"
OP_ITEM="dev"

# GitHub repository details
GH_REPO="https://github.com/codora-io/Github-Action-Workflows"
GH_SECRET_NAME="MY_SECRET"

# Fetch the secret from 1Password using the op command
SECRET_VALUE=$(op item get "$OP_ITEM" --vault "$OP_VAULT")

# Create or update the GitHub repository secret using the gh command
gh secret set "$GH_SECRET_NAME" -r "$GH_REPO" -b "$SECRET_VALUE"

echo "{"GitHub secret '$GH_SECRET_NAME' has been updated."}"


