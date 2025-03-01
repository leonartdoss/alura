module "aws_dev" {
    source          = "../../../infra"
    instance_type   = "t2.micro"
    aws_region      = "eu-west-1"
    key             = "id_rsa_dev"
    security_group  = "general_access_dev"
    instance_name   = "app_server_dev"
}

output "ip_dev" {
    value = module.aws_dev.public_ip
}