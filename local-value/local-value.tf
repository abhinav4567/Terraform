provider "aws" {
  region     = "us-west-2"
}

locals {
  common_tag = {
    Name = "UK Project"
    Owner = "ABhinav Sharma"
}
}

locals {
  us_project  = {
   Name = "US Project"
   Owner = "Cloundnative"
}
}

resource "aws_instance" "Cloudnative" {
  ami           = "ami-00f7e5c52c0f43726" # us-west-2
  instance_type = "t2.micro"
  tags          = local.common_tag
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags             = local.common_tag

}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size              = 40
  tags              = local.common_tag
}

resource "aws_instance" "Cloudnative1" {
  ami           = "ami-00f7e5c52c0f43726" # us-west-2
  instance_type = "t2.micro"
  tags          = local.us_project
}

resource "aws_vpc" "main1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags             = local.us_project

}

resource "aws_ebs_volume" "example1" {
  availability_zone = "us-west-2a"
  size              = 8
  tags              = local.us_project
}
