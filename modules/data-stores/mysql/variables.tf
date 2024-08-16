variable "DB_USERNAME" {
  description = "The username for the database"
  type = string
  sensitive = true
}

variable "DB_PASSWORD" {
  description = "The password for the database"
  type = string
  sensitive = true
}

variable "cluster_name" {
  description = "The name to use for all cluster resources"
  type = string
}

variable "identifier_prefix" {
  description = "The identifier prefix for the database"
  type = string
}

variable "instance_class" {
  description = "The instance class of the database (eg. db.t3.micro)"
  type = string
}

variable "allocated_storage" {
  description = "The storage size of the database"
  type = number
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}

variable "db_remote_state_key" {
  description = "The path of the database's remote state in S3"
  type = string
}

variable "db_name" {
  description = "The name of the database"
  type = string
}

