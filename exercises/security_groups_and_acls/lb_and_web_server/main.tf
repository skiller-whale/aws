
#################################
# DO NOT MODIFY THIS FILE
# This file contains terraform to set up the account for the exercises.
#################################

#################
# The default VPC is created elsewhere - these data tags allow us to reference it.
#################

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

####################################
# Create Load Balancer & Target Group
####################################

resource "aws_lb_target_group" "webapp" {
  name        = "webapp-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb" "webapp" {
  name               = "webapp-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.public.ids
  security_groups    = [aws_security_group.lb.id]
  ip_address_type    = "ipv4"
}

resource "aws_lb_listener" "webapp" {
  load_balancer_arn = aws_lb.webapp.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp.arn
  }
}

###################################################
# Create instances and add them to the target group
###################################################

resource "aws_instance" "webapp" {
  count = var.instance_count

  ami = data.aws_ami.ubuntu.id
  user_data = file("user-data.sh")

  instance_type = "t2.micro"

  security_groups = [
    resource.aws_security_group.webapp.name
  ]

  tags = {
    Name = "WebApp${count.index + 1}"
  }
}

resource "aws_lb_target_group_attachment" "webapp" {
  count = var.instance_count
  target_group_arn = aws_lb_target_group.webapp.arn
  target_id        = aws_instance.webapp[count.index].id
}

#####################################
# Configure Security Groups for LB and instances.
#####################################

resource "aws_security_group" "lb" {
  name = "lb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    # This will only allow traffic to the first webapp instance, regardless of instance_count.
    # This is so learners can edit the SG themselves.
    cidr_blocks = ["${aws_instance.webapp[0].private_ip}/32"]
  }

  lifecycle {
    ignore_changes = [
      egress
    ]
  }
}

resource "aws_security_group" "webapp" {
  name = "webapp-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
