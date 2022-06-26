locals {
  public_subnets = [
    for k, v in aws_subnet.public_subnet : v.id
  ]
}

resource "aws_lb" "alb" {
  name               = "nginx-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.public_subnets

  tags = {
    Name        = "${var.environment_name} Application LB"
    Environment = var.environment_name
  }
}

resource "aws_lb_target_group" "nginx_target_group" {
  name        = "nginx-ecs-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "application-load-balancer-sg"
  description = "Allows inbound HTTP traffic from world"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Inbound HTTP Traffic to ALB"
  }
}