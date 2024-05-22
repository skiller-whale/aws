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

# Subnets

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

# Subnet associations

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

# Security Groups

resource "aws_security_group" "lb" {
  name   = "alb-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
}

resource "aws_security_group" "web" {
  name   = "web-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
