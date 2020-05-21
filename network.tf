#Step 1: Create the network

resource "aws_vpc" "chat-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "chat-vpc"
  }

}

#Creating subnet in availability zone "a"
resource "aws_subnet" "chat-subnet-1" {
  vpc_id                  = aws_vpc.chat-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.AVAILABILITY_ZONE_1
  tags = {
    Name = "chat-subnet-a"
  }
}

#Creating subnet in availability zone "b"
resource "aws_subnet" "chat-subnet-2" {
  vpc_id                  = aws_vpc.chat-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.AVAILABILITY_ZONE_2
  tags = {
    Name = "chat-subnet-2"
  }
}


#Creating internet gateway 
resource "aws_internet_gateway" "chat-internet-gateway" {
  vpc_id = aws_vpc.chat-vpc.id
  tags = {
    Name = "chat-internet-gateway"
  }
}

#Creating a route table for the subnets
resource "aws_route_table" "chat-route-table" {
  vpc_id = aws_vpc.chat-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.chat-internet-gateway.id
  }
  tags = {
    Name = "chat-route-table"
  }
}

#Associating subnet 1 to the route table
resource "aws_route_table_association" "chat-route-table-association-subnet-1" {
  subnet_id      = aws_subnet.chat-subnet-1.id
  route_table_id = aws_route_table.chat-route-table.id
}

#Associating subnet 2 to the route table
resource "aws_route_table_association" "chat-route-table-association-subnet-2" {
  subnet_id      = aws_subnet.chat-subnet-2.id
  route_table_id = aws_route_table.chat-route-table.id

}




