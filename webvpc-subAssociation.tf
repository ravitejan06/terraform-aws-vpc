#Subnet Route Table Association for Web Vpc
#Pub sub 1 association
resource "aws_route_table_association" "pub1_rt_association" {
    subnet_id = aws_subnet.web_pub_sub1.id
    route_table_id = aws_route_table.web_pub_rt.id
}
#pub sub 2 association
resource "aws_route_table_association" "pub2_rt_association" {
    subnet_id = aws_subnet.web_pub_sub2.id
    route_table_id = aws_route_table.web_pub_rt.id
}
#private sub 1 association
resource "aws_route_table_association" "pvt1_rt_association" {
    subnet_id = aws_subnet.web_pvt_sub1.id
    route_table_id = aws_route_table.web_pvt_rt.id
}
#private sub 2 association
resource "aws_route_table_association" "pvt2_rt_association" {
    subnet_id = aws_subnet.web_pvt_sub2.id
    route_table_id = aws_route_table.web_pvt_rt.id
}
#private sub 3 association
resource "aws_route_table_association" "pvt3_rt_association" {
    subnet_id = aws_subnet.web_pvt_sub3.id
    route_table_id = aws_route_table.web_pvt_rt.id
}
#private sub 4 association
resource "aws_route_table_association" "pvt4_rt_association" {
    subnet_id = aws_subnet.web_pvt_sub4.id
    route_table_id = aws_route_table.web_pvt_rt.id
}
