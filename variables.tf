variable "aws_region" {
    default = "us-east-1"
}


variable "ec2_count" {
  default = "1"
}

variable "ami_id" {
    // Kali Linux from Markeplace
    default = "ami-075f17622f23cb5fc"
}

variable "instance_type" {
  default = "t2.micro"
}
