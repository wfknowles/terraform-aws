# variable "server_port" {
#   description = "The port the server will use for HTTP requests"
#   type = number
#   default = 8080
# }

# variable "load_balancer_port" {
#   description = "The port the load balancer will use for HTTP requests"
#   type = number
#   default = 80
# }

variable "cluster_name" {
  description = "The name to use for all cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}

variable "db_remote_state_key" {
  description = "The path of the database's remote state in S3"
  type = string
}

variable "image_id" {
  description = "The ami id of EC2 instances to run (eg. ami-...)"
  type = string
}

variable "instance_type" {
  description = "The type of EC2 instances to run (eg. t2.micro)"
  type = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type = number
}