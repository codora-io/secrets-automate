variable "service_account_token_1pass" {}
variable "vault_id" {}
variable "uuid_id" {}
variable "environment" {
  default = "dev-test"
}
variable "region" {
  default = "ap-northeast-2"
}
# variable "github_repository" {
#   description = "GitHub repository in the format organization/repository"
#   type        = string
#   default     = "codora-io/lexim-aws-infra"
# }
# variable "github_token" {

# }