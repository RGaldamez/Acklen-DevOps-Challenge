#Step 1: Create the network

resource "aws_vpc" "chat-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "chat-vpc"
    }
  
}

#Creating subnet in availability zone "a"
resource "aws_subnet" "chat-subnet-1" {
  vpc_id = aws_vpc.chat-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.AVAILABILITY_ZONE_1
  tags = {
      Name = "chat-subnet-a"
  }
}
resource "aws_subnet" "chat-subnet-2" {
  vpc_id = aws_vpc.chat-vpc.id
  cidr_block = "0.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.AVAILABILITY_ZONE_2
  tags = {
      Name = "chat-subnet-2"
  }
}


