#Create a Public Route Table
resource "aws_route_table" "web_pub_rt" {
  vpc_id = aws_vpc.web_vpc.id
  route {
    cidr_block = var.open_cidr
    gateway_id = aws_internet_gateway.web_igw.id
  }
    tags = {
      "Name" = "Web Public RouteTable"
    }
}
#Create Peering route to secure Vpc in Public Route Table
resource "aws_route" "web_peer_pubroute" {
  route_table_id            = aws_route_table.web_pub_rt.id
  destination_cidr_block    = var.securevpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_x.id
  depends_on                = [aws_route_table.web_pub_rt]
}

#Create Elastic Ip one
resource "aws_eip" "eip_one" {
  vpc = true
  
}

#Create Elastic Ip two
resource "aws_eip" "eip_two" {
  vpc = true
}

#Create first NAT Gateway
resource "aws_nat_gateway" "natgw_one" {
  allocation_id = aws_eip.eip_one.id
  subnet_id     = aws_subnet.web_pub_sub1.id
  tags = {
    Name = "NATGW 1"
  }
}
#Create second NAT Gateway
resource "aws_nat_gateway" "natgw_two" {
  allocation_id = aws_eip.eip_two.id
  subnet_id     = aws_subnet.web_pub_sub2.id
  tags = {
    Name = "NATGW 2"
  }
}

#Create Private Route Table
resource "aws_route_table" "web_pvt_rt" {
  vpc_id = aws_vpc.web_vpc.id
  route {
    cidr_block = var.open_cidr
    nat_gateway_id = aws_nat_gateway.natgw_one.id
  }
    tags = {
      "Name" = "Web Private RouteTable"
    }
}

#Create Peering route to secure Vpc in Private Route Table
resource "aws_route" "web_peer_pvtroute" {
  route_table_id            = aws_route_table.web_pvt_rt.id
  destination_cidr_block    = var.securevpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_x.id
  depends_on                = [aws_route_table.web_pvt_rt]

}