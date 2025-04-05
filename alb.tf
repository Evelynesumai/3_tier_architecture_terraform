# ALB
resource "aws_lb" "three_tier_alb" {
  name               = "three-tier-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.three_tier_web_sg.id]
  subnets            = [
    aws_subnet.public_subnet_tier_1.id,
    aws_subnet.public_subnet_tier_2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "three_tier_alb" 
  }
}


resource "aws_lb_target_group" "three_tier_web_target_group" {
  name     = "three-tier-web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.three_tier_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "three_tier_web_target_group"
  }
}

resource "aws_lb_target_group_attachment" "three_tier_web_server1_attachment" {
  target_group_arn = aws_lb_target_group.three_tier_web_target_group.arn
  target_id        = aws_instance.three_tier_web1_ec2_instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "three_tier_web_server2_attachment" {
  target_group_arn = aws_lb_target_group.three_tier_web_target_group.arn
  target_id        = aws_instance.three_tier_web2_ec2_instance.id
  port             = 80
}
