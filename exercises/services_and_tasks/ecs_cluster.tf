resource "aws_ecs_cluster" "this" {
  name = local.app_name
}
