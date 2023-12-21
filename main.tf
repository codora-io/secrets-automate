provider "external" {
  alias = "op"
}

data "external" "op_get_item" {
  provider = "external.op"

  program = ["bash", "${path.module}/get_1password_secret.sh"]
}

output "secret_value" {
  value = data.external.op_get_item.result["secret_value"]
}
