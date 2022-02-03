#Create a VPC peering between two Vpcs
resource "aws_vpc_peering_connection" "peering_x" {
  peer_vpc_id   = aws_vpc.secure_vpc.id
  vpc_id        = aws_vpc.web_vpc.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}