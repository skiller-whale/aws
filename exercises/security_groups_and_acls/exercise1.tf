# ###################################
# # AMI
# ###################################
# data "aws_ami" "ubuntu" {

#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"]
# }

# ###################################
# # INSTANCE
# ###################################
# resource "aws_instance" "this" {

#   ami = data.aws_ami.ubuntu.id

#   instance_type = "t2.micro"

#   security_groups = [resource.aws_security_group.this.name]

#   tags = {
#     Name = "TerraformInstance"
#   }
# }


# ###################################
# # SECURITY GROUP
# ###################################
# resource "aws_security_group" "this" {
#   name = "terraform-instance-sg"

#   # Egress rule to allow the instance to access the internet.
#   # Note: from_port and to_port are used in Terraform to define a range of ports. They are not related to the direction of traffic.
#   # To define a single port, use the same value for `from_port` and `to_port`.
#   egress {
#     from_port   = 0 # 0 means all ports, and is used when the protocol is "-1"
#     to_port     = 0
#     protocol    = "-1" # -1 means all protocols and ports.
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # TODO: Add an `ingress` rule to allow SSH access from anywhere. Use the `egress` block above as a template, and change the appropriate values.
# }
