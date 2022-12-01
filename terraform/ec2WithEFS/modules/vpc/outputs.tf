### VPC OUTPUT ###

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet0_id" {
  value = aws_subnet.subnet0.id
}

output "subnet1_id" {
  value = aws_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.subnet2.id
}

output "subnet3_id" {
  value = aws_subnet.subnet3.id
}