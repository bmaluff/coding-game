########################### Prod ###################################3
resource "random_integer" "secrets_suffix" {
  max = 3
  min = 1
}
resource "aws_secretsmanager_secret_version" "prod_env" {
  secret_id     = aws_secretsmanager_secret.prod_env.id
  secret_string = file("${path.module}/files/prod_env.json")
  # lifecycle {
  #   ignore_changes = [ secret_string ]
  # }
}

resource "aws_secretsmanager_secret" "prod_env" {
  name = "${var.prod_env_secret_name}_${random_integer.secrets_suffix.result}"
}