provider "aws" {
  region     = "us-east-1"
  access_key = "######################"
  secret_key = "#################################"
}
resource "aws_vpc" "cloudnativevpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "cloudnative"
  }
}
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.cloudnativevpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.cloudnativevpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}


resource "aws_security_group" "cloudnativesg" {
  name        = "cloudnativesg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.cloudnativevpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudnativesg"
  }
}


resource "aws_internet_gateway" "cloudnative-igw" {
  vpc_id = aws_vpc.cloudnativevpc.id

  tags = {
    Name = "cloudnative-igw"
  }
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.cloudnativevpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudnative-igw.id
  }


  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "private-asso" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.cloudnativevpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.cloudnative-nat.id
  }


  tags = {
    Name = "private-rt"
  }
}


resource "aws_route_table_association" "private1-asso" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_key_pair" "cloudnative-key" {
  key_name   = "cloudnative-key"
  public_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

resource "aws_instance" "web" {
  ami           = "ami-0ed9277fb7eb570c9"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.cloudnativesg.id]
  key_name      = "cloudnative-key"


  tags = {
    Name = "Cloudnative-ec2"
  }
}

resource "aws_instance" "db" {
  ami           = "ami-0ed9277fb7eb570c9"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private-subnet.id
  vpc_security_group_ids = [aws_security_group.cloudnativesg.id]
  key_name      = "cloudnative-key"


  tags = {
    Name = "DB-ec2"
  }
}

resource "aws_eip" "cloudnative-publicip" {
  instance = aws_instance.web.id
  vpc      = true
}

resource "aws_eip" "cloudnative-natip" {
  vpc      = true
}

resource "aws_nat_gateway" "cloudnative-nat" {
  allocation_id = aws_eip.cloudnative-natip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "cloudnative-nat"
  }

}

