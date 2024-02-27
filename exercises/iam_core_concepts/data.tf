data "aws_caller_identity" "this" {}

data "aws_region" "current" {}

data "aws_partition" "this" {}

data "aws_ecr_repository" "shared" {
  name        = "whale_server_samtest"
  registry_id = "058264400233"
}
