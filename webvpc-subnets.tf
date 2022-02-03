#Create Public Subnet 1
resource "aws_subnet" "web_pub_sub1" {
    vpc_id = aws_vpc.web_vpc.id
    cidr_block = var.web_pubsub1
    availability_zone = var.az[0]
    tags = {
      "Name" = "Web Public Subnet 1"
    }
}

#Create Public Subnet 2
resource "aws_subnet" "web_pub_sub2" {
    vpc_id = aws_vpc.web_vpc.id
    cidr_block = var.web_pubsub2
    availability_zone = var.az[1]
    tags = {
      "Name" = "Web Public Subnet 2"
    }
}

#Create Private Subnet 1
resource "aws_subnet" "web_pvt_sub1" {
    vpc_id = aws_vpc.web_vpc.id
    cidr_block = var.web_pvtsub1
    availability_zone = var.az[0]
    enable_resource_name_dns_a_record_on_launch = true
    tags = {
      "Name" = "Web Private Subnet 1"
    }
}

#Create Private Subnet 2
resource "aws_subnet" "web_pvt_sub2" {
    vpc_id = aws_vpc.web_vpc.id
    cidr_block = var.web_pvtsub2
    availability_zone = var.az[1]
    enable_resource_name_dns_a_record_on_launch = true
    tags = {
      "Name" = "Web Private Subnet 2"
    }
}

#Create Private Subnet 3
resource "aws_subnet" "web_pvt_sub3" {
    vpc_id = aws_vpc.web_vpc.id
    cidr_block = var.web_pvtsub3
    availability_zone = var.az[0]
    tags = {
      "Name" = "Web Private Subnet 3"
    }
}

#Create Private Subnet 4
resource "aws_subnet" "web_pvt_sub4" {
    vpc_id = aws_vpc.web_vpc.id
    cidr_block = var.web_pvtsub4
    availability_zone = var.az[1]
    tags = {
      "Name" = "Web Private Subnet 4"
    }
}