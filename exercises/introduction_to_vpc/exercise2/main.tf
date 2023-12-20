locals {
  name        = "exercise2"
  cidr_prefix = "172.21"
}

###########################
# Exercise 2 - Subnet types
###########################

# VPC

resource "aws_vpc" "this" {
  cidr_block = "${local.cidr_prefix}.0.0/16"

  tags = {
    Name = local.name
  }
}

# Internet gateway

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name} - Internet gateway"
  }
}

# This route is functional and will be associated with
# nat, subnet-1, and subnet-5
resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${local.name} - Internet gateway"
  }
}

# Subnets

resource "aws_subnet" "nat" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "${local.cidr_prefix}.0.0/22"

  availability_zone = "eu-west-1a"

  tags = {
    Name = "${local.name}-nat"
    Tier = "nat"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.4.0/22"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${local.name}-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.8.0/22"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${local.name}-subnet-2"
  }
}

resource "aws_subnet" "subnet_3" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.12.0/22"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${local.name}-subnet-3"
  }
}

resource "aws_subnet" "subnet_4" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.16.0/22"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${local.name}-subnet-4"
  }
}

resource "aws_route_table_association" "nat_to_igw" {
  subnet_id      = aws_subnet.nat.id
  route_table_id = aws_route_table.igw.id
}

resource "aws_route_table_association" "subnet_1_to_igw" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.igw.id
}

resource "aws_route_table_association" "subnet_4_to_igw" {
  subnet_id      = aws_subnet.subnet_4.id
  route_table_id = aws_route_table.igw.id
}

# # The NAT gateway

resource "aws_eip" "nat_gateway" {
  domain = "vpc"

  tags = {
    Name = local.name
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.nat.id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${local.name} - NAT gateway"
  }
}

resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name} - NAT gateway"
  }
}

resource "aws_route" "nat_gateway" {
  route_table_id = aws_route_table.nat_gateway.id

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

# The private subnets

resource "aws_route_table_association" "subnet_3_to_nat" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.nat_gateway.id
}
