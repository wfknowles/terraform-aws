variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

variable "load_balancer_port" {
  description = "The port the load balancer will use for HTTP requests"
  type = number
  default = 80
}