
#################################
# ECS Task Definition
#################################

resource "aws_ecs_task_definition" "this" {
  family                   = "whale-app"

  # task_role_arn            = aws_iam_role.task_role.arn #TODO - Uncomment - this links the task to a role it can use to perform AWS actions.

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

# # This creates the role, and specifies the Terraform block containing the assume role policy (AKA the trust policy).
# resource "aws_iam_role" "task_role" {
#   name = "whale-task-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
# }

# data "aws_iam_policy_document" "assume_role_policy" {
#   statement {
#     effect = "Allow"

#     actions = [
#       # TODO - decide on these
#     ]

#     # TODO - Add a resources or principals block
#   }
# }

#################################
# Secrets Manager IAM Policy
#################################

# # TODO - add the policy to talk to secrets manager
# # Questions we can ask - do you think we need to grant any list actions? No, because it's a service and we know exactly what we want. Could also trigger this with "why not reuse the existing policy?"

# data "aws_iam_policy_document" "allow_secret_access" {
#   statement {
#     effect = "Allow"
#     actions = [
#       # TODO - decide on these
#     ]
#     # TODO - Add a resources or principals block
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

# Solution - expectation from learners is just to make it work.
# Optional is to ensure the policy is limited just to the secret it needs.
