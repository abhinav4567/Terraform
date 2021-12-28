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

variable "instancetag" {
  type = list
  default = ["dev-dep","test-dep","prod-dep"]
}

variable "mapvar" {
  type = map
  default  = {
    us-west-2a = "t2.micro"
    us-west-2b = "t2.medium"
    us-west-2c = "t2.nano"
}
}
resource "aws_instance" "dev-team" {
  ami = "ami-00f7e5c52c0f43726"
  instance_type = var.mapvar["us-west-2a"]
  tags = {
   name = var.instancetag[0]
  }
}

resource "aws_instance" "test-team" {
  ami = "ami-00f7e5c52c0f43726"
  instance_type = var.mapvar["us-west-2a"]
  tags = {
    name = var.instancetag[1]
}
}

resource "aws_instance" "prod-team" {
  ami = "ami-00f7e5c52c0f43726"
  instance_type = var.mapvar["us-west-2c"]
  tags = {
    name = var.instancetag[2]
}
}

