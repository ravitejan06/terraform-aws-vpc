#create a Security group for Web Servers

resource "aws_security_group" "web_sg" {
    name = "Web Server SG"
    description = "Allow Inbound traffic to ALB"
    vpc_id = aws_vpc.web_vpc.id
    ingress {
    description      = "Inbound from My ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    #cidr_blocks      = [aws_vpc.web_vpc.cidr_block]
    security_groups = [aws_security_group.alb_sg.id]
  }
  ingress {
    description      = "Tcp traffic from Bastion host"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    #cidr_blocks      = [aws_vpc.secure_vpc.cidr_block]
    security_groups = [aws_security_group.bastion_sg.id]
  }
  ingress {
    description      = "Tcp traffic from My IP"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.myip_addr]
  }
  egress {
    description      = "Tcp traffic from Web SG"
    from_port        = 0
    to_port          = 0
    protocol         = "all"
    cidr_blocks      = [var.webvpc_cidr]
  }

}

#Create ASG Launch Configuration
resource "aws_launch_configuration" "asg_config" {
  name          = "web_config"
  image_id      = var.web_ami
  instance_type = "t2.micro"
  key_name = var.webec2key
  security_groups = [aws_security_group.web_sg.id]
}

#Create Auto Scaling Group
resource "aws_autoscaling_group" "my_asg" {
  name                      = "My ASG"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.asg_config.name
  vpc_zone_identifier       = [aws_subnet.web_pvt_sub1.id, aws_subnet.web_pvt_sub2.id]
  target_group_arns = [aws_lb_target_group.alb_tg.arn]
  termination_policies = ["OldestInstance"]
}


