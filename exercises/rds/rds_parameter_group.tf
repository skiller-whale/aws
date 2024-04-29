resource "aws_db_parameter_group" "custom_postgres16" {
  name   = "${local.name}-postgres16"
  family = "postgres16"

  # STEP 3 - Disable SSL
  # parameter {
  #   name  = "rds.force_ssl"
  #   value = "0"
  # }
}
