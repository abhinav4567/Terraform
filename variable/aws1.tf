provider "aws" {
  region     = "us-west-2"
}

variable "elbname" {
  type = string
}

variable "azname" {
  type = list
  default = ["us-west-2a","us-west-2b","us-west-2c"]
}

variable "timeout" {
  type = number
}

resource "aws_elb" "bar" {
  name               = var.elbname
  availability_zones = var.azname


  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  
  health_check {

    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = var.timeout
  connection_draining         = true
  connection_draining_timeout = var.timeout

  tags = {
    Name = "cloudnative"
  }
}

variable "instancetype" {
  type = list
  default = ["t2.micro","t2.nano","t2.medium","dev-team","test-team","prod-team"]
}

resource "aws_instance" "dev-team" {
  ami = "ami-00f7e5c52c0f43726"
  instance_type = var.instancetype[0]
  tags = {
   name = var.instancetype[3]
  }
}

resource "aws_instance" "test-team" {
  ami = "ami-0e21d4d9303512b8e"
  instance_type = var.instancetype[1]
  tags = {
    name = var.instancetype[4]
}
}

resource "aws_instance" "prod-team" {
  ami = "ami-0b28dfc7adc325ef4"
  instance_type = var.instancetype[2]
  tags = {
    name = var.instancetype[5]
}
}

