### EC2 OUTPUT FOR EFS ###

output "private_key" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}

output "aws_instance_public_ip" {
  value = aws_instance.ec2.public_ip
}

output "aws_instance_id" {
  value = aws_instance.ec2.id
}

output "aws_instance_subnet_id" {
  value = aws_instance.ec2.subnet_id
}

output "security_group_id" {
  value = aws_security_group.terramino.id
}