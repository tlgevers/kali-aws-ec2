terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "{$HOME}/.aws/credentials"
  profile                 = "dev"
}

module "vpc" {
    source = "./vpc"
    vpc_name = "kali_linux"
    vpc_cidr = "192.168.0.0/16"
    public_cidr = "192.168.1.0/24"
    private_cidr = "192.168.2.0/24"
}

resource "aws_instance" "kali" {
  instance_type = var.instance_type
  ami = var.ami_id
  subnet_id     = module.vpc.subnet_public_id
  key_name = "kali-ssh.pem"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "kali-eh"
  }
  depends_on = [ module.vpc.vpc_id, module.vpc.igw_id ]

  user_data = <<EOF
    sudo apt-get update
  EOF

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
