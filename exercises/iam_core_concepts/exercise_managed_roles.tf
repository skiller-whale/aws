
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
  name = "whale-task-execution"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

###################################
# Managed Policy - TODO - comment this out
###################################

resource "aws_iam_role_policy_attachment" "execution_role_managed_policy_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

###################################
# Manual Policy - TODO - uncomment and finish
###################################

# data "aws_iam_policy_document" "execution_role_policy_document" {
#   statement {
#     effect = "Allow"
#     actions = [
#       # TODO: Get these from the managed policy
#     ]
#     resources = ["*"]
#   }
#   # TODO: Add more statements as needed
# }

# # These are Terraform blocks that turn what you've written above into a policy and attach it to the role.
# resource "aws_iam_policy" "execution_role_policy" {
#   name   = "whale-task-execution-policy"
#   policy = data.aws_iam_policy_document.execution_role_policy_document.json
# }
# resource "aws_iam_role_policy_attachment" "execution_role_policy_attachment" {
#   role       = aws_iam_role.task_execution_role.name
#   policy_arn = aws_iam_policy.execution_role_policy.arn
# }
