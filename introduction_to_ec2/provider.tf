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

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-1"

  default_tags {
    tags = {
      Purpose       = "Learner Created Exercise Resource"
      CurriculumKey = "ec2"
      ModuleKey     = "introduction_to_ec2"
      CreatedBy     = var.attendance_id
      CreatedWith   = "Terraform"
    }
  }
}
