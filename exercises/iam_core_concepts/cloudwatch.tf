resource "aws_cloudwatch_log_group" "this" {
  name              = "/fargate/${aws_ecs_cluster.this.name}/${local.app_name}"
  retention_in_days = 1
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"
    actions = [
      "logs:DeleteLogGroup",
    ]
    resources = ["${aws_cloudwatch_log_group.this.arn}"]
  }

  # A new statement for you to complete
  # statement {
  #   effect = "Allow"
  #   [...]
  # }
}

resource "aws_iam_policy" "cloudwatch" {
  name   = "${local.app_name}-cloudwatch-policy"
  policy = data.aws_iam_policy_document.cloudwatch.json
}
