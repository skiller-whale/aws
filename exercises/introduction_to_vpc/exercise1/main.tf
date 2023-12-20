#######################################
# Exercise 1 - A VPC from the ground up
#######################################

###########################
# Step 1 - The VPC
###########################

# resource "aws_vpc" "this" {
#   cidr_block = "172.20.0.0/20"

#   tags = {
#     Name = "exercise1"
#   }
# }

###########################
# Step 2 - The gateway
###########################

# resource "aws_internet_gateway" "this" {
#   vpc_id = aws_vpc.this.id

#   tags = {
#     Name = "exercise1"
#   }
# }

###########################
# Step 3 - The subnets
###########################

# resource "aws_subnet" "public_a" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "172.20.0.0/22"
#   availability_zone = "eu-west-1a"

#   tags = {
#     Name = "exercise1-public-a"
#   }
# }

# resource "aws_subnet" "public_b" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "172.20.4.0/22"
#   availability_zone = "eu-west-1b"

#   tags = {
#     Name = "exercise1-public-b"
#   }
# }

# resource "aws_subnet" "public_c" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "172.20.8.0/22"
#   availability_zone = "eu-west-1c"

#   tags = {
#     Name = "exercise1-public-c"
#   }
# }

###########################
# Step 4 - The route table
###########################

# resource "aws_route_table" "this" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.this.id
#   }

#   tags = {
#     Name = "exercise1"
#   }
# }

###########################
# Step 5 - Subnet routes
###########################

# resource "aws_route_table_association" "public_a_to_igw" {
#   subnet_id      = aws_subnet.public_a.id
#   route_table_id = aws_route_table.this.id
# }

# resource "aws_route_table_association" "public_b_to_igw" {
#   subnet_id      = aws_subnet.public_b.id
#   route_table_id = aws_route_table.this.id
# }

# resource "aws_route_table_association" "public_c_to_igw" {
#   subnet_id      = aws_subnet.public_c.id
#   route_table_id = aws_route_table.this.id
# }

