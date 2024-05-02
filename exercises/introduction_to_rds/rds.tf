# # STEP 1 - Create an RDS instance

# resource "aws_db_instance" "mydb" {
#   identifier = "${local.name}-mydb" # This is the name of the RDS instance.

#   allocated_storage      = 5 # 5 GB of storage, because this is a test DB and doesn't need much space.
#   db_name                = "mydb" # This is the name of the database that will be created on the instance.
#   engine                 = "postgres"
#   engine_version         = "16.2"
#   instance_class         = "db.t4g.micro" # This is a very small instance, because you're not running any queries in this session.
#   username               = "root"
#   password               = "seacret_bassword"
#   storage_encrypted      = true

#   parameter_group_name   = aws_db_parameter_group.custom_postgres16.name
#   db_subnet_group_name   = aws_db_subnet_group.private.name
#   vpc_security_group_ids = [aws_security_group.rds_rules.id]

#   # STEP 2 - Delection protection
#   # deletion_protection = true
# }
