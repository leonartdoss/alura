variable "is_prod_env" {
    type = bool
}

variable "aws_region" {
    type = string
}

variable "key" {
    type = string
}

variable "instance_name" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "security_group" {
    type = string
}

variable "group_name" {
    type = string
}

variable "min_size" {
    type = number
}

variable "max_size" {
    type = number
}