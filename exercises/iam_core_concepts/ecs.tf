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



