resource "aws_vpc" "this" {
  cidr_block = "${var.cidr_prefix}.0.0/16"

  tags = {
    Name = var.name
  }
}
