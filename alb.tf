###############################################################################
# alb.tf
###############################################################################

# 1) Application Load Balancer
resource "aws_lb" "web_alb" {
  name               = "my-web-alb"
  load_balancer_type = "application"

  # Attach the ALB to your two public subnets
  subnets = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]

  # You may need a dedicated SG for the ALB that allows inbound HTTP/HTTPS
  # For simplicity, if you're reusing an existing SG, reference it here:
  # security_groups = [aws_security_group.lb_sg.id]

  ip_address_type = "ipv4"

  tags = {
    Name = "my-web-alb"
  }
}

# 2) Target Group for Web Servers
resource "aws_lb_target_group" "web_tg" {
  name        = "my-web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"
  
  # Health check configuration
  health_check {
    protocol = "HTTP"
    port     = "80"
    path     = "/"
    matcher  = "200"
    interval = 30
    timeout  = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }

  tags = {
    Name = "my-web-tg"
  }
}

# 3) ALB Listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  # Forward traffic to our Target Group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# 4) Register EC2 Instances as Targets
#    - Each web server instance must be attached to the Target Group
resource "aws_lb_target_group_attachment" "web_server_a_attachment" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web_server_a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_server_b_attachment" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web_server_b.id
  port             = 80
}
