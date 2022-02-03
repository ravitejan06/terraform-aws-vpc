#Create NACL for Public Subnets (ALB)
resource "aws_network_acl" "pub_nacl" {
  vpc_id = aws_vpc.web_vpc.id
  subnet_ids = [aws_subnet.web_pub_sub1.id, aws_subnet.web_pub_sub2.id ]
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.myip_addr
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = aws_subnet.web_pvt_sub1.cidr_block
    from_port  = 1024
    to_port    = 65535
  }
   ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = aws_subnet.web_pvt_sub2.cidr_block
    from_port  = 1024
    to_port    = 65535
  }
  #ingress {
   # protocol   = "tcp"
   # rule_no    = 130
   # action     = "allow"
   # cidr_block = var.myip_addr
   # from_port  = 22
   # to_port    = 22
  #}
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.open_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "Public NACL"
  }
}
#Create NACL for Private Subnets (web servers)
resource "aws_network_acl" "pvt_nacl" {
  vpc_id = aws_vpc.web_vpc.id
  subnet_ids = [aws_subnet.web_pvt_sub1.id, aws_subnet.web_pvt_sub2.id, aws_subnet.web_pvt_sub3.id, aws_subnet.web_pvt_sub4.id]
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    #cidr_block = aws_vpc.web_vpc.cidr_block
    cidr_block = aws_subnet.web_pub_sub1.cidr_block
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 105
    action     = "allow"
    cidr_block = aws_subnet.web_pub_sub2.cidr_block
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = aws_vpc.secure_vpc.cidr_block
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "-1"
    rule_no    = 120
    action     = "allow"
    cidr_block = aws_vpc.web_vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.web_vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.secure_vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "Private NACL"
  }
}

