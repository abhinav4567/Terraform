provider "aws" {
  region     = "us-west-2"
  access_key = "XXXXXXXXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

resource "aws_instance" "cloud-native" {
  ami           = "ami-00f7e5c52c0f43726" # us-west-2
  instance_type = "t2.micro"
  key_name      = "cloud-native"
  vpc_security_group_ids = [aws_security_group.cloudnativesg.id]
tags = {
 name = "cloud-native"
}
}
resource "aws_key_pair" "cloud-native" {
  key_name = "cloud-native"
  public_key = "ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXl"
}
resource "aws_eip" "lb" {
  instance = aws_instance.cloud-native.id
  vpc      = true
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "cloudnativesg" {
  name        = "cloudnativesg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "cloud-native"
  }
}
