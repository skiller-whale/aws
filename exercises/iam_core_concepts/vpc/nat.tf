# resource "aws_eip" "this" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "this" {
#   allocation_id = aws_eip.this.id

#   subnet_id = aws_subnet.public_a.id

#   tags = {
#     Name = "${var.name} - NAT gateway"
#   }
# }

# resource "aws_route_table" "nat" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.this.id
#   }

#   tags = {
#     Name = "${var.name} - NAT gateway"
#   }
# }
