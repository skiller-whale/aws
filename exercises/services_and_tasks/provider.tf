#################################
# DO NOT MODIFY THIS FILE
# This file configures terraform to interact with AWS, and does not need editing for the exercises.
#################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    region = "eu-west-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      Purpose       = "Learner Created Exercise Resource"
      CurriculumKey = "ec2"
      ModuleKey     = "ecs_services_and_tasks"
      CreatedBy     = var.attendance_id
      CreatedWith   = "Terraform"
    }
  }
}
