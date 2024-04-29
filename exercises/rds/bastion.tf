#################################
# DO NOT MODIFY THIS FILE
# This file contains terraform to set up the account for the exercises.
#################################

resource "aws_security_group" "bastion" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami       = data.aws_ami.ubuntu.id
  user_data = file("${path.module}/bastion-user-data.sh")

  subnet_id = aws_subnet.public_a.id

  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.bastion.id,
    aws_security_group.to_rds.id
  ]

  tags = {
    Name = "${local.name}-bastion"
  }
}
