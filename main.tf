// Very basic ExampleAppServerInstance for creating basic ec2 t2.micro Linux instance
// TODO: Modify how variables are used now they are hard coded! 
// Different variables can be applied through command line or another .tf file

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

// Define basic variables, TODO place these another file or read them in command line!
variable "awsprops" {
    default = {
    region = "us-east-1"
    ami = "ami-026b57f3c383c2eec"
    itype = "t2.micro"
    publicip = true
    keyname = "kari_aws"    // NOTE: precreated need to be changed!!
    secgroupname = "one-aws-sec-group"
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
}

// Define AWS security group
resource "aws_security_group" "project-one-aws" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "project-one-aws" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
