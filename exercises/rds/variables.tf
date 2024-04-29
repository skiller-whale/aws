#################################
# DO NOT MODIFY THIS FILE
# This file contains terraform to set up the account for the exercises.
#################################

variable "attendance_id" {
  description = "Your attendance ID" # NB: For tagging ECR, there seems to be a sensitivity to certain characters. (at least one of <,>,_ or -)
}
