
variable "security_group_name" {}
variable "vpc_id"  {}
variable "cidr_public_subnet" {}


output "dev_vpc_ec2_security_group_id" {
  value = aws_security_group.dev_vpc_ec2_sec_group.id
}   

output "dev_vpc_RDS_mysql_sec_group_id" {
  value = aws_security_group.dev_vpc_RDS_mysql_sec_group.id
}


resource "aws_security_group" "dev_vpc_ec2_sec_group" {
  name        = var.security_group_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Groups to allow SSH(22) and HTTP(80)"
  }
}

resource "aws_security_group" "dev_vpc_RDS_mysql_sec_group" {
  name = "mysql-Security-group"
  description = "Allow Inbound Traffic"
  vpc_id = var.vpc_id

  ingress  {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.cidr_public_subnet 
  }
}
