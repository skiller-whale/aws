#################################
# DO NOT MODIFY THIS FILE
# This file contains terraform to set up the account for the exercises.
#################################

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

# Route for public subnets

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

# Public subnets

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${local.cidr_prefix}.4.0/22"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name}-public-a"
    Tier = "public"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${local.cidr_prefix}.8.0/22"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name}-public-b"
    Tier = "public"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${local.cidr_prefix}.12.0/22"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name}-public-c"
    Tier = "public"
  }
}

resource "aws_route_table_association" "public_a_to_igw" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.igw.id
}

resource "aws_route_table_association" "public_b_to_igw" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.igw.id
}

resource "aws_route_table_association" "public_c_to_igw" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.igw.id
}

# NAT

resource "aws_eip" "nat_gateway_a" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_gateway_a.id

  subnet_id = aws_subnet.public_a.id

  tags = {
    Name = "${local.name}-nat-a"
  }
}

resource "aws_route_table" "nat_gateway_a" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }

  tags = {
    Name = "${local.name} - NAT gateway"
  }
}

# Private subnets

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.16.0/22"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${local.name}-private-a"
    Tier = "private"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.20.0/22"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${local.name}-private-b"
    Tier = "private"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.24.0/22"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${local.name}-private-c"
    Tier = "private"
  }
}

resource "aws_route_table_association" "private_a_to_nat" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.nat_gateway_a.id
}

resource "aws_route_table_association" "private_b_to_nat" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.nat_gateway_a.id
}

resource "aws_route_table_association" "private_c_to_nat" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.nat_gateway_a.id
}

resource "aws_db_subnet_group" "private" {
  name       = "main"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id, aws_subnet.private_c.id]
}

