locals {
  name        = "exercise3a"
  cidr_prefix = "172.22"
}

# The VPC

resource "aws_vpc" "this" {
  cidr_block = "${local.cidr_prefix}.0.0/20"

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

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${local.name} - Internet gateway"
  }
}

# The public subnets

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.0.0/28"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${local.name}-public-a"
    Tier = "public"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.0.16/28"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${local.name}-public-b"
    Tier = "public"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.cidr_prefix}.0.32/28"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${local.name}-public-c"
    Tier = "public"
  }
}

# resource "aws_subnet" "public_d" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "${local.cidr_prefix}.0.48/28"
#   availability_zone = "eu-west-1a"

#   tags = {
#     Name = "${local.name}-public-d"
#     Tier = "public"
#   }
# }

resource "aws_route_table_association" "public_a_to_igw" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "public_b_to_igw" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "public_c_to_igw" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.this.id
}

# resource "aws_route_table_association" "public_d_to_igw" {
#   subnet_id      = aws_subnet.public_d.id
#   route_table_id = aws_route_table.this.id
# }

