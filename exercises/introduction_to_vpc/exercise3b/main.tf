# The VPC

resource "aws_vpc" "this" {
  cidr_block = "${local.exercise3.cidr_prefix}.0.0/20"

  tags = {
    Name = local.exercise3.name
  }
}

# Internet gateway

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.exercise3.name} - Internet gateway"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${local.exercise3.name} - Internet gateway"
  }
}

# The public subnets

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.exercise3.cidr_prefix}.0.0/28"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${local.this.name}-public-a"
    Tier = "public"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.exercise3.cidr_prefix}.0.64/28"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${local.this.name}-public-b"
    Tier = "public"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.exercise3.cidr_prefix}.0.128/28"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${local.this.name}-public-c"
    Tier = "public"
  }
}

resource "aws_route_table_association" "public_a_to_igw" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.this.id
}

