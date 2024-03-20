#################################
# DO NOT MODIFY THIS FILE
# This file contains terraform to set up the account for the exercises.
#################################

locals {
  app_name = "whale"
}

#################################
# VPC
#################################

module "vpc" {
  source = "./vpc"
}


#################################
# Load Balancer
#################################

resource "aws_security_group" "load_balancer" {
  vpc_id = module.vpc.vpc_id
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
  subnets            = module.vpc.public_subnet_ids
  security_groups    = [aws_security_group.load_balancer.id]
}

resource "aws_lb_target_group" "this" {
  name        = local.app_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  deregistration_delay = 1

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

#################################
# ECS Cluster and Service
#################################

resource "aws_ecs_cluster" "this" {
  name = "webapp"
}

resource "aws_ecs_service" "this" {
  name            = "${local.app_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = module.vpc.public_subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = local.app_name
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 200
  force_new_deployment               = true
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/fargate/${aws_ecs_cluster.this.name}/${local.app_name}"
  retention_in_days = 1
}

#################################
# ECS Task Security Groups
#################################

resource "aws_security_group" "ecs_tasks" {
  name   = "ecs-tasks"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "ecs_tasks" {
  security_group_id = aws_security_group.ecs_tasks.id

  ip_protocol = -1

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ecs_tasks_http" {
  security_group_id = aws_security_group.ecs_tasks.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}
