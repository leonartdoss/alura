terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.16"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region  = var.aws_region
}

resource "aws_key_pair" "ssh_key" {
    key_name   = var.key
    public_key = file("../.ssh/${var.key}.pub")
}

resource "aws_launch_template" "machine" {
    image_id      = "ami-03fd334507439f4d1"
    instance_type = var.instance_type
    key_name      = var.key
    tags = {
        Name = var.instance_name
    }
    security_group_names = [var.security_group]
    user_data = filebase64("../scripts/ansible_main.sh")
}

resource "aws_default_vpc" "default_vpc" {

}

resource "aws_lb_target_group" "target_group_lb" {
    name        = "target_group"
    port        = "8000"
    protocol    = "HTTP"
    vpc_id      = aws_default_vpc.default_vpc.id
}

resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn   = aws_lb.load_balancer.arn
    port                = "8000"
    protocol            = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.target_group_lb.arn
    }
}

resource "aws_autoscaling_group" "scaling_group" {
    availability_zones  = ["${var.aws_region}a", "${var.aws_region}b"]
    name                = var.group_name
    min_size            = var.min_size
    max_size            = var.max_size
    launch_template {
      id        = aws_launch_template.machine.id
      version   = "$Latest"
    }
    target_group_arns = [aws_lb_target_group.target_group_lb.arn]
}

resource "aws_default_subnet" "subnet_1" {
    availability_zone = "${var.aws_region}a"
    tags = {
        Name = "subnet_1"
    }
}

resource "aws_default_subnet" "subnet_2" {
    availability_zone = "${var.aws_region}b"
    tags = {
        Name = "subnet_2"
    }
}

resource "aws_lb" "load_balancer" {
    internal = false
    subnets = [
        aws_default_subnet.subnet_1.id,
        aws_default_subnet.subnet_2.id
    ]
}