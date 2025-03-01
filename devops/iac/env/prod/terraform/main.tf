module "aws_prod" {
    source          = "../../../infra"
    instance_type   = "t2.micro"
    aws_region      = "eu-west-1"
    key             = "id_rsa_prod"
    security_group  = "general_access_prod"
    instance_name   = "app_server_prod"
}

output "ip_dev" {
    value = module.aws_prod.public_ip
}