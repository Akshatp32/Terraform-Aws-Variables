terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.60.0"
    }
  }
}

provider "aws" {
  region     =  var.region_Name
  access_key =  var.access_key
  secret_key =  var.secret_key
}

# genrate key using tls module 
resource "tls_private_key" "ins_key" {
  algorithm = "RSA"
}

# genrate key pair on aws 
resource "aws_key_pair" "mykey" {
  key_name   = "ins_test_key"
  public_key = tls_private_key.ins_key.public_key_openssh
}

# crate a custom vpc 
resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidrblock
  instance_tenancy = "default"
  
  tags = {
    Name = var.vpc_name
  }
}

# create subnet1 as public 
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet1_cidrblock
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet1_Public_Myvpc"
  }
}

# create subnet2 as public 
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet2_cidrblock
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet2_Public_Myvpc"
  }
}

# create security group for instance 
resource "aws_security_group" "Mysec_grp" {
  name        = "ALL TRAFFIC RULE"
  description = "Allow ALL TRAFFIC"
  vpc_id      = aws_vpc.myvpc.id
  ingress {
    description      = "ALLOW ALL"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "MySecgrp"
  }
}

# crate a internetgateway for vpc
resource "aws_internet_gateway" "myvpcigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "MyVpc_igw"
  }
}

# create a route table for Public Sudbnet 
resource "aws_route_table" "Publicrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myvpcigw.id
  }

  tags = {
    "Name" = "PublicRT_MyVpc"
  }
}

# Associate subnet1 with publicRT 
resource "aws_route_table_association" "publicsubnet1assosiate" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.Publicrt.id
}

# create private instance 
resource "aws_instance" "test" {
  ami                    = var.instance_ami
  instance_type          = var.server_instance
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.Mysec_grp.id]
  key_name               = aws_key_pair.mykey.key_name

  tags = {
    "Name" = "private"
  }
}

# download key pair file in local system 
resource "local_file" "private_key" {
  content  = tls_private_key.ins_key.private_key_pem
  filename = "private_key.pem"
}

# output of public ip
output "outputip_Public" {
  value = aws_instance.test.public_ip
}

# output of key pair file 
output "ins_key" {
  value     = tls_private_key.ins_key.private_key_pem
  sensitive = true
}