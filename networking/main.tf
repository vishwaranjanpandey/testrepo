variable "vpc_name" {}
variable "vpc_cidr" {}
variable "cidr_public_subnet" {}
variable "ap_avalibility_zone" {}
variable "cidr_private_subnet" {}


output "dev_vpc_id" {
  value = aws_vpc.dev_vpc.id
}

output "dev_vpc_public_sub_id" {
  value = aws_subnet.dev_vpc_public_sub.*.id
}
output "dev_vpc_private_sub_id " {
    value = aws_subnet.dev_vpc_private_sub.*.id
}

resource "aws_vpc" "dev_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
      Name = var.vpc_name
    }
}  

resource "aws_subnet" "dev_vpc_public_sub" {
  count      = length(var.cidr_public_subnet)
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.ap_avalibility_zone, count.index)
  tags = {
    Name = "dev_vpc_public_subnet-${count.index +1}"
  }
}

resource "aws_subnet" "dev_vpc_private_sub" {
  count = length(var.cidr_private_subnet)
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.ap_avalibility_zone, count.index)
  tags = {
    Name = "dev_vpc_private_sub-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "dev_vpc_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = dev_vpc_igw
  }
}

resource "aws_route_table" "dev_vpc_public_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_vpc_igw.id
  }

  tags = {
    Name = dev_vpc_public_route_table
  }
}

resource "aws_route_table" "dev_vpc_private_route_table" {
    vpc_id = aws_vpc.dev_vpc.id
    tags = {
        Name = dev_vpc_private_route_table
    }
}

resource "aws_route_table_association" "public_route_table_association" {
  count = length(aws_subnet.dev_vpc_public_sub)
  subnet_id      = aws_subnet.dev_vpc_public_sub[count.index].id
  route_table_id = aws_route_table.dev_vpc_public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
    count = length(aws_subnet.dev_vpc_private_sub)
    subnet_id = aws_subnet.dev_vpc_private_sub[count.index].id
    route_table_id = aws_route_table.dev_vpc_private_route_table.id
}
