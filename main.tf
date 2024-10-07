module "networking" {
  source = "./networking"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  cidr_public_subnet = var.cidr_public_subnet
  cidr_private_subnet = var.cidr_private_subnet
  ap_avalibility_zone = var.ap_avalibility_zone
}

module "security_group" {
    source = "./security_group"
    security_group_name = var.security_group_name
  
}