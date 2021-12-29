provider "aws" {
  region     = "us-west-2"
}

variable "instancetype" {
  type = map
  default  = {
    "dev" =  "t2.micro",
    "test" = "t2.nano",
    "prod" = "t2.medium"
}
}
variable "image" { 
  type = list
  default = ["ami-00f7e5c52c0f43726","ami-0e21d4d9303512b8e","ami-0b28dfc7adc325ef4"]
}

variable "input" {}

resource "aws_instance" "dev" {
  instance_type = var.instancetype["dev"]
  ami = var.image[0]
  count = var.input == "dev" ? 1 : 0
   tags = {
     Name = "Dev Dep"
}
}
resource "aws_instance" "Test" {
  instance_type = var.instancetype["test"]
  ami = var.image[1]
  count = var.input == "test" ? 2 : 0
   tags = {
     Name = "Test Dep"
}
}
resource "aws_instance" "Prod" {
  instance_type = var.instancetype["prod"]
  ami = var.image[2]
  count = var.input == "prod" ? 3 : 0
   tags = {
     Name = "Prod Dep"
}
}
