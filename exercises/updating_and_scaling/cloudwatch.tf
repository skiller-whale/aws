resource "aws_cloudwatch_log_group" "this" {
  name              = "/fargate/${aws_ecs_cluster.this.name}/${local.app_name}"
  retention_in_days = 1
}
