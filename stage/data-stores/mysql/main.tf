provider "aws" {
  region = "us-east-2"
}

module "data_store_mysql" {
  source = "../../../modules/data-stores/mysql"

  cluster_name = "learning-terraform-stage"
  identifier_prefix = "learning-terraform"
  instance_class = "db.t3.micro"
  allocated_storage = 10
  db_remote_state_bucket = "learning-terraform-state-07123"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  db_name = "stage"
}