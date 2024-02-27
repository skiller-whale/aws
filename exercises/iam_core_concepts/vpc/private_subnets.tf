# resource "aws_subnet" "private_a" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "${var.cidr_prefix}.20.0/22"
#   availability_zone = "eu-west-1a"

#   tags = {
#     Name = "${var.name}-private-a"
#     Tier = "private"
#   }
# }

# resource "aws_subnet" "private_b" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "${var.cidr_prefix}.24.0/22"
#   availability_zone = "eu-west-1b"

#   tags = {
#     Name = "${var.name}-private-b"
#     Tier = "private"
#   }
# }

# resource "aws_subnet" "private_c" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "${var.cidr_prefix}.28.0/22"
#   availability_zone = "eu-west-1c"

#   tags = {
#     Name = "${var.name}-private-c"
#     Tier = "private"
#   }
# }

# resource "aws_route_table_association" "private_a" {
#   subnet_id      = aws_subnet.private_a.id
#   route_table_id = aws_route_table.nat.id
# }

# resource "aws_route_table_association" "private_b" {
#   subnet_id      = aws_subnet.private_b.id
#   route_table_id = aws_route_table.nat.id
# }

# resource "aws_route_table_association" "private_c" {
#   subnet_id      = aws_subnet.private_c.id
#   route_table_id = aws_route_table.nat.id
# }
