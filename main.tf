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
    cidr_public_subnet = tolist(module.networking.public_subnet_cidr_block)
  
}

module "ec2_instance" {
  source = "./ec2"
  ami_id = var.ami_id
  tag_name = "dev_ec2_instance"
  instance_type = var.instance_type
  public_key_name = "1st_keypair.pem"
  subnet_id = tolist(module.networking.dev_vpc_public_sub)[0]
  security_group = module.security_group.dev_vpc_ec2_security_group_id
  enable_public_ip_address = true
  
}