###### EC2 CONFIG ######

### KEY PAIR ###

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name   = "efs-key-2"
  public_key = tls_private_key.my_key.public_key_openssh
}

### EC2 SECURITY GROUP ###

resource "aws_security_group" "terramino" {
  name   = "learn-ec2-and-rds"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "EFS mount point"
    from_port   = 2049
    to_port     = 2049
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

### EC2 INSTANCE ###

resource "aws_instance" "ec2" {
  ami                         = var.image_id
  instance_type               = var.type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.terramino.id]
  subnet_id                   = var.vpc_subnet0_id
  associate_public_ip_address = true

}


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