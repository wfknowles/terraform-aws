provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "learning-terraform-db"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t3.micro"
  skip_final_snapshot = true
  db_name = "example_db"

  username = var.DB_USERNAME
  password = var.DB_PASSWORD
}

terraform {
  backend "s3" {
    bucket = "learning-terraform-state-07123"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "learning-terraform-state-locks"
    # Encryption At Rest
    encrypt = true
  }
}