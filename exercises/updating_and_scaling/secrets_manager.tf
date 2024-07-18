resource "random_password" "password" {
  length  = 32
  special = true
}

resource "aws_secretsmanager_secret" "app_secret" {
  name_prefix             = "${local.app_name}-secrets"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  secret_id = aws_secretsmanager_secret.app_secret.id

  secret_string = "my-secret-${random_password.password.result}"
}

resource "aws_secretsmanager_secret" "extremely_secret" {
  name_prefix             = "extremely-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "extremely_secret" {
  secret_id = aws_secretsmanager_secret.extremely_secret.id

  secret_string = "YOU SHOULD NEVER SEE THIS!"
}
