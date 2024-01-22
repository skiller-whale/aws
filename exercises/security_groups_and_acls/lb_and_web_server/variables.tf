#################################
# DO NOT MODIFY THIS FILE
# This file contains terraform to set up the account for the exercises.
#################################

variable "instance_count" {
    description = "Number of EC2 Instances"
    default = 1

    # A number between 1 and 3
    type = number

    validation {
        condition = var.instance_count >= 1 && var.instance_count <= 3
        error_message = "The number of instances must be between 1 and 3"
    }
}
