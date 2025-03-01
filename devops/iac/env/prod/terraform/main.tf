module "aws_prod" {
    source          = "../../../infra"
    instance_type   = "t2.micro"
    aws_region      = "eu-west-1"
    key             = "id_rsa_prod"
    security_group  = "general_access_prod"
    instance_name   = "app_server_prod"
    group_name      = "prod"
    min_size        = 1
    max_size        = 10
}
