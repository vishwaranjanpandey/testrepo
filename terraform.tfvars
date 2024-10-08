vpc_cidr             = "10.0.0.0/16"
vpc_name             = "dev_project_vpc"
cidr_public_subnet   = ["10.0.1.0/24", "10.0.2.0/24"]
cidr_private_subnet  = ["10.0.3.0/24", "10.0.4.0/24"]
ap_availability_zone = ["ap-south-1a", "ap-south-1b"]

ami_id = "ami-078264b8ba71bc45e"
instance_type = "t2.micro"