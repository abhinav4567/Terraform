provider "aws" {
  region     = "us-west-2"
}

variable "instancetag" {
  type = list
  default = ["dev-dep","test-dep","prod-dep"]
}

variable "instancetype" {
  type = list
  default = ["t2.micro","t2.nano","t2.medium"]
}

resource "aws_instance" "cloudnative" {
  ami = "ami-00f7e5c52c0f43726"
  instance_type = var.instancetype[count.index]
  count = 3
 tags = {
  Name = var.instancetag[count.index]
}
}
