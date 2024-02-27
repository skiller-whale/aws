resource "random_password" "password" {
  length  = 32
  special = true
}

resource "aws_secretsmanager_secret" "this" {
  name_prefix             = "${local.app_name}-secrets"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id

  secret_string = random_password.password.result
}
