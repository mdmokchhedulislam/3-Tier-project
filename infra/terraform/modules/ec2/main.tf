
resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  vpc_id      = var.vpc_id
  ingress { 
    from_port = 80
   to_port = 80
    protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
      }
  egress  { 
    from_port = 0
   to_port = 0
    protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
      }
}


resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  vpc_id      = var.vpc_id
  ingress { 
    from_port = 5000
     to_port = 5000
      protocol = "tcp" 
    security_groups = [aws_security_group.lb_sg.id] 
  }
  egress  { 
    from_port = 0
   to_port = 0
    protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
      }
}


resource "aws_lb" "app_lb" {
  name               = "my-app-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_id
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}


resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-server-"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  key_name      = "my-key"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app-server"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  vpc_zone_identifier = var.subnet_id_private
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]
}