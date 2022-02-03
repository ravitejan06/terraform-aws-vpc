#1 Create a secure Vpc
resource "aws_vpc" "secure_vpc" {
    cidr_block = var.securevpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      "Name" = "Secure Vpc"
    }
  
}
#2 Create Internet Gateway
resource "aws_internet_gateway" "secure_igw" {
    vpc_id = aws_vpc.secure_vpc.id
    tags = {
      "Name" = "Secure IGW"
    }
  
}
#3 Create Public Subnet
resource "aws_subnet" "bastion_pub_sub" {
    vpc_id = aws_vpc.secure_vpc.id
    cidr_block = var.bastion_subcidr
    availability_zone = var.az[0]

    map_public_ip_on_launch = true
    enable_resource_name_dns_a_record_on_launch = true
    tags = {
      "Name" = "Bastion Public Subnet"
    }
  
}
#4 Create a Public Route table
resource "aws_route_table" "bastion_pub_rt" {
    vpc_id = aws_vpc.secure_vpc.id
    route {
    cidr_block = var.open_cidr
    gateway_id = aws_internet_gateway.secure_igw.id
  }
    tags = {
      "Name" = "Bastion Public RouteTable"
    }
}
#5 Create Peering route to Web Vpc
resource "aws_route" "secure_peer_route" {
  route_table_id            = aws_route_table.bastion_pub_rt.id
  destination_cidr_block    = var.webvpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_x.id
  depends_on                = [aws_route_table.bastion_pub_rt]
}
#6 Create Bastion Subnet Route Table Association
resource "aws_route_table_association" "bastionpub_rt_association" {
    subnet_id = aws_subnet.bastion_pub_sub.id
    route_table_id = aws_route_table.bastion_pub_rt.id
}
#7 Create a SG for Bastion host
resource "aws_security_group" "bastion_sg" {
    name = "Bastion SG"
    description = "Allow inbound SSH traffic from My IP"
    vpc_id = aws_vpc.secure_vpc.id
    ingress {
    description      = "SSH from My IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.myip_addr]
    
  } 
  egress {
    description      = "SSH from My IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.web_pvtsub1, var.web_pvtsub2]
  }
}
#8 Create a Bastion host Instance
resource "aws_instance" "bastion_ec2" {
    ami = var.bastion_ami
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.bastion_sg.id]
    subnet_id = aws_subnet.bastion_pub_sub.id
    key_name = var.bastionkeypair
    tags = {
      "Name" = "Bastion Host"
    }
}
