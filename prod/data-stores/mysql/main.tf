provider "aws" {
  region = "us-east-2"
}

module "data_store_mysql" {
  source = "../../../modules/data-stores/mysql"

  cluster_name = "learning-terraform-prod"
  identifier_prefix = "learning-terraform"
  instance_class = "db.t3.micro"
  allocated_storage = 10
  db_remote_state_bucket = "learning-terraform-state-07123"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  db_name = "prod"
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours"{
  scheduled_action_name = "scale-out-during-business-hours"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night"{
  scheduled_action_name = "scale-in-at-night"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}