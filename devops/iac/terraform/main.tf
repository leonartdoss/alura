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
    region  = "eu-west-1"
}

resource "aws_instance" "app_server" {
    ami           = "ami-03fd334507439f4d1"
    instance_type = "t2.micro"
    key_name      = "personal-connection"
    # user_data     = <<-EOF
    #     #!/bin/bash
    #     cd /home/ubuntu
    #     echo "<h1>Hello, World by Terraform!</h1>" > index.html
    #     nohup busybox httpd -f -p 8080 &
    # EOF
    tags = {
        Name = "Terraform Ansible Python"
    }
}
