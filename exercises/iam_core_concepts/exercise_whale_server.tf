
#################################
# ECS Task Definition
#################################

resource "aws_ecs_task_definition" "this" {
  family                   = "whale-app"

  # #TODO 1 - Uncomment - this links the task to a role it can use to perform AWS actions.
  # task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name      = local.app_name,
      image     = data.aws_ecr_repository.shared.repository_url, # This uses an image from another account containing shared ECR images.
      environment = [
        { "name" : "SECRET_ID", "value" : aws_secretsmanager_secret.whale_app_secret.arn } # This gets the secret ARN from the piece of Terraform that creates the secret.
      ],

      # IGNORE THE BELOW - it's needed to make things work, but it's not the focus of the exercise.
      essential = true,
      portMappings = [{ containerPort = 80 }],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name,
          # awslogs-create-group  = "true", # For this to work, you can't use the managed policy, because it doesn't have the "logs:CreateLogGroup" action.
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = local.app_name
        }
      }
    }
  ])

  # IGNORE THE BELOW - it's needed to make things work, but it's not the focus of the exercise.
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn
}

#################################
# Task Role & Assume Role Policy
#################################

# # TODO 2 - Uncomment this section

# # This creates the role, and specifies the Terraform block containing the assume role policy (AKA the trust policy).
# resource "aws_iam_role" "task_role" {
#   name = "whale-task-role"
#   assume_role_policy = data.aws_iam_policy_document.trust_policy.json
# }

# data "aws_iam_policy_document" "trust_policy" {
#   statement {
#     effect = "Allow"

#     # TODO 3 - choose the appropriate action for a trust policy
#     actions = [
#       "Replace with correct action"
#     ]

#     # TODO 4 - uncomment the correct block for the trust policy

#     ## OPTION 1
#     # principals {
#     #   type        = "Service"
#     #   identifiers = ["secretsmanager.amazonaws.com"]
#     # }

#     ## OPTION 2
#     # principals {
#     #   type        = "Service"
#     #   identifiers = ["ecs-tasks.amazonaws.com"]
#     # }

#     ## OPTION 3
#     # resources = [aws_secretsmanager_secret.whale_app_secret.arn]
#   }
# }

#################################
# Secrets Manager IAM Policy
#################################

# # TODO 5 - Uncomment this section (to the end of the file)

# data "aws_iam_policy_document" "allow_secret_access" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "secretsmanager:GetSecretValue"
#     ]

#     # TODO 6 - uncomment the correct block so the ECS task can access the secret.

#     ## OPTION 1
#     # principals {
#     #   type        = "Service"
#     #   identifiers = ["secretsmanager.amazonaws.com"]
#     # }

#     ## OPTION 2
#     # resources = ["*"]

#     ## OPTION 3
#     # resources = [aws_secretsmanager_secret.whale_app_secret.arn]
#   }
# }

# # These are Terraform blocks that turn what you've written above into a policy and attach it to the role.
# resource "aws_iam_policy" "allow_secret_access" {
#   name   = "whale-allow-secret-access-policy"
#   policy = data.aws_iam_policy_document.allow_secret_access.json
# }
# resource "aws_iam_role_policy_attachment" "allow_secret_access" {
#   role       = aws_iam_role.task_role.name
#   policy_arn = aws_iam_policy.allow_secret_access.arn
# }
