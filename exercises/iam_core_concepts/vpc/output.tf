# output "private_subnet_ids" {
#   value = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id,
#   ]
# }

output "public_subnet_ids" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id,
  ]
}

output "vpc_id" {
  value = aws_vpc.this.id
}
