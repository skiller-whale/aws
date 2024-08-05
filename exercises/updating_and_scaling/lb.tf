resource "aws_security_group" "load_balancer" {
  vpc_id = aws_vpc.this.id
}

resource "aws_vpc_security_group_ingress_rule" "lb_http" {
  security_group_id = aws_security_group.load_balancer.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "lb_http" {
  security_group_id = aws_security_group.load_balancer.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  referenced_security_group_id = aws_security_group.ecs_tasks.id
}

resource "aws_lb" "this" {
  name               = "${local.app_name}-lb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id,
  ]

  security_groups = [aws_security_group.load_balancer.id]
}

resource "aws_lb_target_group" "this" {
  name        = local.app_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id

  deregistration_delay = 15

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
}
