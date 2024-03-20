data "aws_region" "current" {}

data "aws_ecr_repository" "shared" {
  name        = "whale_server"
  registry_id = "058264400233"
}
