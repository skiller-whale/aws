####################################################################################################
# This file uses some predefined terraform to set up a load balanced web server using EC2 instances.
#
# Do not modify anything in this file except the value of `instance_count`.
# You should make any other changes (e.g. to security groups) using the AWS console.
####################################################################################################
module "lb_and_web_server" {
  source = "./lb_and_web_server"
  depends_on = [ aws_default_vpc.default ]

  instance_count = 1 # Change this value according to the slide instructions.
}
