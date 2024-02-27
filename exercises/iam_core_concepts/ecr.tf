data "aws_iam_policy_document" "ecr" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
    ]
    resources = [data.aws_ecr_repository.shared.arn]
  }

  # A new statement for you to complete
  # statement {
  #   effect = "Allow"
  #   [...]
  # }
}

resource "aws_iam_policy" "ecr" {
  name   = "${local.app_name}-ecr-policy"
  policy = data.aws_iam_policy_document.ecr.json
}

