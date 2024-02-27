resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${var.cidr_prefix}.4.0/22"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-a"
    Tier = "public"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${var.cidr_prefix}.8.0/22"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-b"
    Tier = "public"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${var.cidr_prefix}.12.0/22"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-c"
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
