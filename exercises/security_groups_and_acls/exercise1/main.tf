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

# resource "aws_security_group" "this" {
#   name = "terraform-instance-sg"

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_instance" "this" {

#   ami = data.aws_ami.ubuntu.id

#   instance_type = "t2.micro"

#   security_groups = [resource.aws_security_group.this.name]

#   tags = {
#     Name = "TerraformInstance"
#   }
# }

