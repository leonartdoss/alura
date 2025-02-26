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
    key_name    = "personal-connection"

    tags = {
        Name = "Primeira instância"
    }
}
