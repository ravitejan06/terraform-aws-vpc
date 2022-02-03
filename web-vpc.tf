########################################################################################################

#Create a Web Vpc
resource "aws_vpc" "web_vpc" {
  cidr_block = var.webvpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
      "Name" = "Web Vpc"
    }
}

#Create a IGW for web Vpc
resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id
  tags = {
      "Name" = "Web IGW"
    }
  
}
