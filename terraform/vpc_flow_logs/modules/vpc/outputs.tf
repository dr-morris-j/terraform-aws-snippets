### VPC OUTPUT ###

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet0_id" {
  value = aws_subnet.subnet0.id
}

output "vpc_arn" {
  value = aws_vpc.vpc[0].arn
}