resource "aws_ecs_service" "service_customer1" {
  name            = "${local.app_name}-service-customer1"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id,
      aws_subnet.public_c.id,
    ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = local.app_name
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  force_new_deployment               = true
}

# Add Autoscaling to the ECS Service
resource "aws_appautoscaling_target" "ecs_service_customer1" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.service_customer1.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_service_customer1" {
  name               = "customer1"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service_customer1.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_customer1.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_customer1.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 30.0
  }
}

resource "aws_ecs_service" "service_customer2" {
  name            = "${local.app_name}-service-customer2"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 4
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id,
      aws_subnet.public_c.id,
    ]
    assign_public_ip = true
  }

  deployment_minimum_healthy_percent = 75
  deployment_maximum_percent         = 100
  force_new_deployment               = true
}
