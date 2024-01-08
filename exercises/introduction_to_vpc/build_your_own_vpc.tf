#######################################
# A VPC from the ground up
#######################################

###########################
# Step 1 - The VPC
###########################

# resource "aws_vpc" "vpc" {
#   cidr_block = "172.20.0.0/16" # 65536 addresses - allows for 64 subnets with 1024 addresses each

#   tags = {
#     Name = "my-own-vpc"
#   }
# }

#######################################
# Step 2 - The Gateway and Route Table
#######################################

# resource "aws_internet_gateway" "internet_gateway" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "my-own-vpc-internet-gateway"
#   }
# }

# # This Route Table contains a single route that sends all traffic to the internet gateway (unless it's for an address within the VPC).
# resource "aws_route_table" "vpc_internet_gateway" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.internet_gateway.id
#   }

#   tags = {
#     Name = "my-own-vpc-public-route-table"
#   }
# }

###########################
# Step 3 - The First Subnet
###########################

# resource "aws_subnet" "public_a" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "172.20.0.0/22" # 1024 addresses
#   availability_zone = "eu-west-1a"

#   tags = {
#     Name = "my-own-vpc-public-a"
#   }
# }

# # This links the subnet to the shared route table.
# resource "aws_route_table_association" "public_a_to_igw" {
#   subnet_id      = aws_subnet.public_a.id
#   route_table_id = aws_route_table.vpc_internet_gateway.id
# }

################################
# Step 4 - Second Public Subnet
################################

# TODO - create the other public subnet.

###################################
# Step 5 - Isolated Subnet
###################################

# resource "aws_subnet" "isolated_subnet_a" {
#   vpc_id = aws_vpc.vpc.id

#   cidr_block = "172.20.32.0/22" # 1024 addresses - This is the 8th possible /22 subnet in the VPC
#   availability_zone = "eu-west-1a"
#
#   tags = {
#     Name = "my-own-vpc-isolated-a"
#   }
# }

###################################
# Step 6 - Private Subnet & NAT Gateway
###################################

# resource "aws_subnet" "private_subnet_a" {
#   vpc_id = aws_vpc.vpc.id

#   cidr_block = "172.20.64.0/22" # 1024 addresses - This is the 16th possible /22 subnet in the VPC
#   availability_zone = "eu-west-1a"
#
#   tags = {
#     Name = "my-own-vpc-private-a"
#   }
# }

# # Allocate a public IP address for your NAT gateway.
# resource "aws_eip" "nat_gateway_a" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat_gateway_a" {
#   allocation_id = aws_eip.nat_gateway_a.id # Link your NAT gateway to the IP you created.

#   # TODO 1 - only one of the two lines below is correct - choose one and uncomment it:
#   # subnet_id = aws_subnet.public_a.id # Option 1 - Deploy the NAT gateway in the public subnet
#   # subnet_id = aws_subnet.private_subnet_a.id # Option 2 -Deploy the NAT gateway in the private subnet
#
#   tags = {
#     Name = "my-own-vpc-nat-a"
#   }
# }

###################################
# Step 7 - Private Subnet Route Tables
###################################

# # We need the extra route table because we want each AZ (and therefore, each subnet) to have its own NAT gateway.
# resource "aws_route_table" "private_subnet_a" {

#   vpc_id = aws_vpc.vpc.id
#   # Route all traffic out through the NAT gateway - the route table for the public subnets will then route it through the internet gateway.
#   route {
#     cidr_block     = "Add the appropriate CIDR block to route Internet traffic to the NAT gateway" # TODO 2
#     nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
#   }
#
#   tags = {
#     Name = "my-own-vpc-private-route-table-a"
#   }
# }

# # TODO 3 - Add the appropriate route table association to link the private subnet to the route table.

###################################
# Step 7 - Create a second private subnet, in eu-west-1b
###################################
