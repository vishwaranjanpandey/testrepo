variable "vpc_cidr" {
    type = string
    description = "public subnet CIDR value"  
}

variable "vpc_name" {
    type = string
    description = "devops project vpc"
}

variable "cidr_public_subnet" {
    type = list(string)
    description = "public subnet CIDR values"
}

variable "cidr_private_subnet" {
    type = list(string)
    description = "private subnet CIDR value"
}

variable "ap_availability_zone" {
    type = list(string)
    description = "availability zone"
}

variable "ami_id" {
  type = string
  description = "ami_id_for_ec2_instance"
}

variable "instance_type" {
  type = string
  description = "ec2_instance_type"
}
