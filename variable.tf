variable "access_key" {
    description =   "Enter Your Acoount Access-Key"
    type    =  string
}

variable "secret_key" {
    description =   "Enter Your Acoount Secret-Key"
    type    =  string
}

variable "region_Name"{
    description =   "Enter your Prefered Region"
    type    =   string
	default = "ap-south-1"
}

variable "server_instance" {
    description =   "Enter your Instance Type"
    type    =   string
}

variable "instance_ami" {
    description =   "enter your OS Image ami"
    type    =   string
}

variable "create_vpc" {
  description   =   "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description   =   "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "vpc_cidrblock" {
    description =   "set the cidr block ip"
    type    =   string
    default =   "10.0.0.0/16"      
}

variable "subnet" {
    description = "create subnet1 in vpc"
    type = number
    default = 2
}

variable "subnet1_cidrblock" {
    description = "set subnet1 cidr block ip"
    type = string
    default = "10.0.1.0/24"
}

variable "subnet2_cidrblock" {
    description = "set subnet2 cidr block ip"
    type = string
    default = "10.0.2.0/24"
}

variable "public_rt" {
    description = "set the public route table cidr block"
    type = string
    default = "0.0.0.0/0"  
}

variable "ingress_sg" {
    description = "enter value of you security group"
    type = map
    default = {
        "22" = ["0.0.0.0/0"]
        "80" = ["0.0.0.0/0"]
        "443" = ["0.0.0.0/0"]
        "0" = ["0.0.0.0/0"]
    }
}

variable "egress_sg" {
    description = "enter value of you security group"
    type = map
    default = {
        "22" = ["0.0.0.0/0"]
        "80" = ["0.0.0.0/0"]
        "443" = ["0.0.0.0/0"]
        "0" = ["0.0.0.0/0"]
    }
}
