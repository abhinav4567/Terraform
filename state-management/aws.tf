provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}

terraform {
  backend "s3" {
    bucket = "cloudnative2025india"
    key    = "cloudnative/project"
    region = "us-west-2"
    access_key = ""
    secret_key = ""
    dynamodb_table = "cloudnativeproject"

  }
}


resource "aws_instance" "DB" {
  ami           = "ami-00f7e5c52c0f43726" # us-west-2
  instance_type = "t2.micro"
 tags = {
  Name = "PROD"
}
}

resource "aws_instance" "WEB" {
  ami           = "ami-00f7e5c52c0f43726" # us-west-2
  instance_type = "t2.micro"
 tags = {
  Name = "PROD"
}
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
 tags = {
  Name = "Hello"
}
}

