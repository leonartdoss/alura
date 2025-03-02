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
    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = var.instance_name
        }
    }
    security_group_names = [var.security_group]
    user_data = var.is_prod_env ? filebase64("../../../scripts/ansible_main.sh") : ""
}

resource "aws_default_vpc" "default_vpc" {

}

resource "aws_lb_target_group" "target_group_lb" {
    name        = "targetgroup"
    port        = "8000"
    protocol    = "HTTP"
    vpc_id      = aws_default_vpc.default_vpc.id
    count = var.is_prod_env ? 1 : 0
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
    count = var.is_prod_env ? 1 : 0
}

resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn   = aws_lb.load_balancer[0].arn
    port                = "8000"
    protocol            = "HTTP"
    default_action {
        type                = "forward"
        target_group_arn    = aws_lb_target_group.target_group_lb[0].arn
    }
    count = var.is_prod_env ? 1 : 0
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
    target_group_arns = var.is_prod_env ? [aws_lb_target_group.target_group_lb[0].arn] : []
}

resource "aws_autoscaling_policy" "prod_scaling_policy" {
    name = "terraform-scaling"
    autoscaling_group_name = var.group_name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
    count = var.is_prod_env ? 1 : 0
}