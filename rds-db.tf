#Create DB Subnet Group
resource "aws_db_subnet_group" "db_subnetgrp" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.web_pvt_sub3.id, aws_subnet.web_pvt_sub4.id]

  tags = {
    Name = "My DB subnet group"
  }
}
 #Create a DB Security Group
 resource "aws_security_group" "db_sg" {
  name = "RDS SG"
  description = "Allow DB port access"
  vpc_id = aws_vpc.web_vpc.id
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    description      = "Allow DB port access" 
    security_groups =  [aws_security_group.web_sg.id]
  }
}

#Create RDS DB in private Subnets
resource "aws_db_instance" "my_rds" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t2.micro"
  name                 = "myrdsdb"
  username             = "admin"
  password             = "password123"
  db_subnet_group_name = aws_db_subnet_group.db_subnetgrp.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
}