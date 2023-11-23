#################################
# DO NOT MODIFY THIS FILE
# This file contains terraform to set up the account for the exercises.
#################################

# This will create or adopt a default VPC in the region specified in the provider block.
# The learner account starts with no VPC, so we expect this to create one.
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Add a security group to allow SSH access from anywhere.
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
