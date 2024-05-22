#################################
# Security group
#################################

resource "aws_security_group" "ecs_tasks" {
  name   = "ecs-tasks"
  vpc_id = aws_vpc.this.id
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

#################################
# IAM Execution role
#################################

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution_role" {
  name = "${local.app_name}-task-execution"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "execution_role_managed_policy_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#################################
# IAM Task role
#################################

resource "aws_iam_role" "task_role" {
  name               = "${local.app_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

data "aws_iam_policy_document" "allow_secret_access" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [aws_secretsmanager_secret.app_secret.arn]
  }
}

resource "aws_iam_policy" "allow_secret_access" {
  name   = "${local.app_name}-allow-secret-access-policy"
  policy = data.aws_iam_policy_document.allow_secret_access.json
}

resource "aws_iam_role_policy_attachment" "allow_secret_access" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.allow_secret_access.arn
}

#################################
# Task definition
#################################

resource "aws_ecs_task_definition" "this" {
  family = "${local.app_name}-app"

  task_role_arn = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name  = local.app_name,
      image = data.aws_ecr_repository.shared.repository_url,
      environment = [
        { "name" : "SECRET_ID", "value" : aws_secretsmanager_secret.app_secret.arn }
      ],

      essential    = true,
      portMappings = [{ containerPort = 80 }],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name,
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = local.app_name
        }
      }
    }
  ])

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn
}

#################################
# WARNING: Broken IAM Execution role
#################################

resource "aws_iam_role" "broken_task_execution_role" {
  name = "${local.app_name}-broken-task-execution"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

#################################
# WARNING: Broken Task definition
#################################

resource "aws_ecs_task_definition" "broken_task_definition" {
  family = "${local.app_name}-broken-app"

  task_role_arn = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name  = local.app_name,
      image = data.aws_ecr_repository.shared.repository_url,
      environment = [
        { "name" : "SECRET_ID", "value" : aws_secretsmanager_secret.app_secret.arn }
      ],

      essential    = true,
      portMappings = [{ containerPort = 80 }],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name,
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = local.app_name
        }
      }
    }
  ])

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.broken_task_execution_role.arn
}
