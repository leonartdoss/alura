module "aws_dev" {
    source  = "../../../infra"
    instance = "t2.micro"
    aws_region = "eu-west-1"
    key = "../.ssh/id_rsa_dev"
}

output "ip_dev" {
    value = module.aws_dev.public_ip
}