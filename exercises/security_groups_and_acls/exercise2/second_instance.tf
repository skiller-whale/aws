# resource "aws_instance" "webapp2" {

#   ami = data.aws_ami.ubuntu.id

#   instance_type = "t2.micro"

#   security_groups = [
#     resource.aws_security_group.webapp.name
#   ]

#   user_data = file("user-data.sh")

#   tags = {
#     Name = "WebApp2"
#   }
# }

# resource "aws_lb_target_group_attachment" "webapp2" {
#   target_group_arn = aws_lb_target_group.webapp.arn
#   target_id        = aws_instance.webapp2.id
# }
