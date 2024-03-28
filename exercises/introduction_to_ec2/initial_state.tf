#################################
# DO NOT MODIFY THIS FILE
# This file contains terraform to set up the account for the exercises.
#################################

# This will create or adopt a default VPC in the region specified in the provider block.
# The learner account starts with no VPC, so we expect this to create one.
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

