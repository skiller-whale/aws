# STEP 1 - Create an RDS instance

# resource "aws_db_instance" "mydb" {
#   identifier = "${local.name}-mydb"

#   allocated_storage      = 5
#   db_name                = "mydb"
#   db_subnet_group_name   = aws_db_subnet_group.private.name
#   engine                 = "postgres"
#   engine_version         = "16.2"
#   instance_class         = "db.t4g.micro"
#   username               = "foo"
#   password               = "foofoobarbar"
#   parameter_group_name   = aws_db_parameter_group.custom_postgres16.name
#   vpc_security_group_ids = [aws_security_group.rds_rules.id]

#   # STEP 2 - Delection protection
#   # deletion_protection = true

#   # STEP 4 0 Multi-AZ
#   # multi_az = true

#   # STEP 5 - Apply changes
#   # ...
# }
