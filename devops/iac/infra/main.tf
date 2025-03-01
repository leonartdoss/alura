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

output "public_ip" {
    value = aws_instance.app_server.public_ip
}