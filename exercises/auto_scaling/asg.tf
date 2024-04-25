resource "aws_security_group" "stress" {
  name   = "stress-sg"
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

resource "aws_launch_template" "stress" {
  name          = "stress-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.stress.id]

  monitoring {
    enabled = true
  }

  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "stress" {
  name = "stress-asg"

  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id
  ]

  desired_capacity = 1
  max_size         = 3
  min_size         = 0

  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.stress.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "stress"
    propagate_at_launch = true
  }
}
