module "networking" {
  source = "./networking"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  cidr_public_subnet = var.cidr_public_subnet
  cidr_private_subnet = var.cidr_private_subnet
  ap_availability_zone = var.ap_availability_zone
}

module "security_group" {
    source = "./security_group"
    security_group_name = "SG for EC2 to enable SSH(22) and HTTP(80)" 
    vpc_id   = module.networking.dev_vpc_id
  
}
