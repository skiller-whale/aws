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

data "aws_iam_policy_document" "task_execution_role" {
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

  assume_role_policy = data.aws_iam_policy_document.task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.ecr.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch.arn
}

data "aws_iam_policy_document" "task_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.this.account_id}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${data.aws_caller_identity.this.account_id}"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  name = "${local.app_name}-task"

  assume_role_policy = data.aws_iam_policy_document.task_role.json
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${local.app_name}-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name      = local.app_name,
      image     = data.aws_ecr_repository.shared.repository_url,
      essential = true,
      portMappings = [
        {
          containerPort = 80
        }
      ],
      environment = [
        { "name" : "SECRET_ID", "value" : aws_secretsmanager_secret.this.arn }
      ],
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
}

