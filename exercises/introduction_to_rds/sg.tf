#################################
# DO NOT MODIFY THIS FILE
# This file contains terraform to set up the account for the exercises.
#################################

resource "aws_security_group" "to_rds" {
  name   = "to-rds-sg"
  vpc_id = aws_vpc.this.id
}

resource "aws_security_group" "rds_rules" {
  name   = "rds-rules-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.to_rds.id]
  }
}
