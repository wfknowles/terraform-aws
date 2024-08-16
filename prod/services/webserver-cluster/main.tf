provider "aws" {
  region = "us-east2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = "learning-terraform-stage"
  db_remote_state_bucket = "learning-terraform-state-07123"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro" # "m4.large" - actual
  image_id = "ami-003932de22c285676"
  min_size = 2
  max_size = 10
}