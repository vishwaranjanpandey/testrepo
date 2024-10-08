variable "tag_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "public_key_name" {}
variable "security_group" {}
variable "enable_public_ip_address" {}

output "dev_ec2_instance_id" {
  value = aws_instance.dev_ec2_instance.id
  }


resource "aws_instance" "dev_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.security_group
  key_name = var.public_key_name
  subnet_id = var.subnet_id
  associate_public_ip_address = var.enable_public_ip_address

  tags = {
    Name = var.tag_name
  }
}