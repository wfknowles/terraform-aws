provider "aws" {
  region = "us-east-2"
}

# Configuration for each instance managed by ASG
resource "aws_launch_configuration" "example" {
  image_id = "ami-003932de22c285676"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = templatefile("user-data.sh", {
    server_port = var.server_port
    db_address = data.terraform_remote_state.db.outputs.address
    db_port = data.terraform_remote_state.db.outputs.port
  })

  # Required when using a launch configuration with an auto scaling group
  lifecycle {
    create_before_destroy = true
  }
}

# Configuration for ASG
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB" # defaults to "EC2"

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "learning-terraform-asg"
    propagate_at_launch = true
  }
}

# Security group for application instances
resource "aws_security_group" "instance" {
  name = "learning-terraform-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "learning-terraform-state-07123"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"
  }
}

# Application Load Balancer
resource "aws_lb" "example" {
  name = "learning-terraform-lb"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default.ids
  security_groups = [aws_security_group.alb.id]
}

# HTTP Listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = var.load_balancer_port
  protocol = "HTTP"

  # By default, return a simple 404 response
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page Not Found"
      status_code = 404
    }
  }
}

# Security group for ALB
resource "aws_security_group" "alb" {
  name = "terraform-example-alb"

  # Allow inbound HTTP requests
  ingress {
    from_port = var.load_balancer_port
    to_port = var.load_balancer_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "asg" {
  name = "learning-terraform-asg"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

# Listener rule that sends requests that match any path to the target group
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

terraform {
  backend "s3" {
    bucket = "learning-terraform-state-07123"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "learning-terraform-state-locks"
    # Encryption At Rest
    encrypt = true
  }
}