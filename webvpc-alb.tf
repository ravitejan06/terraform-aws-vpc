#create a Security group for ALB
resource "aws_security_group" "alb_sg" {
    name = "ALB SG"
    description = "Allow Inbound traffic to ALB"
    vpc_id = aws_vpc.web_vpc.id
    ingress {
    description      = "Inbound from world"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.myip_addr]
    
  } 
  egress {
    description      = "outbound to Vpc"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.web_pvtsub1, var.web_pvtsub2]
  }
}

#Create an ALB Target Group
resource "aws_lb_target_group" "alb_tg" {
  name     = "ALB-TG-1"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.web_vpc.id
  depends_on = [aws_internet_gateway.web_igw]
  health_check {
    healthy_threshold = 3
    interval = 6
    timeout = 5
    unhealthy_threshold = 2
    path = "/"
    port = 80
    protocol = "HTTP"

  }
}

#Create an ALB
resource "aws_lb" "my_alb" {
  name               = "My-Public-ALB"
  depends_on = [aws_lb_target_group.alb_tg]
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.web_pub_sub1.id, aws_subnet.web_pub_sub2.id]
  ip_address_type = "ipv4"
}

#Create Listner for ALB 
resource "aws_lb_listener" "alb_listner" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}