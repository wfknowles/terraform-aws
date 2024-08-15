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