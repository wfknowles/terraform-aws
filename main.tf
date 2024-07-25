provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "awsInstance" {
  ami = "ami-003932de22c285676"
  instance_type = "t2.micro"

  tags = {
    Name = "learning-terraform"
  }
}