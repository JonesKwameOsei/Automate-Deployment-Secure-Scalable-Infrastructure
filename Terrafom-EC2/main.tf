################################################################################
# Declaring Resources
################################################################################

# Create instance SSH key pair
resource "aws_key_pair" "nginx_auth" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create Instance. 
# Defining EC2 instance
resource "aws_instance" "ec2_web" {
  ami               = data.aws_ami.ubuntu_latest.id
  instance_type     = var.instance_type
  vpc_security_group_ids = [data.aws_ssm_parameter.sg.value]
  subnet_id = data.aws_ssm_parameter.private-subnet-2.value
  availability_zone = var.availability_zones[1]
  user_data         = file("userdata.tpl")
  associate_public_ip_address = true
  root_block_device {
    volume_size = var.root_size
  }
  tags = {
    Name = "${var.name}-Nginx-Server"
  }
}

# # create Application balancer
resource "aws_lb" "application_load_balancer" {
  name                       = "${local.resource_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [data.aws_ssm_parameter.alb_sg.value]
  subnets                    = [for subnet in [data.aws_ssm_parameter.public-subnet-1.value, data.aws_ssm_parameter.public-subnet-2.value] : subnet]
  enable_deletion_protection = false

  tags = {
    Name = "${local.resource_name}-ALB"
  }
}

# create target group and attach to the instance 
resource "aws_lb_target_group" "alb_target_group" {
  name     = "${local.resource_name}-Alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path                = "/healthz"
    interval            = 30
    port                = var.http_port
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 4
  }
  depends_on = [aws_lb.application_load_balancer]
  tags = {
    Name = "${local.resource_name}-TG"
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = var.protocol_tg
      status_code = var.status_tg
    }
  }
}

resource "aws_launch_template" "Autoscaling-server" {
  name_prefix            = "${local.resource_name}-lunch-template"
  image_id               = data.aws_ami.ubuntu_latest.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_ssm_parameter.auto_sg.value]
}

# Attach target groups to alb
resource "aws_lb_target_group_attachment" "ec2-instances1" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.ec2_web.id
  port             = 80
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "Auto-sg" {
  name                = "Nginx-Autoscaling group"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  force_delete        = true
  target_group_arns   = [aws_lb_target_group.alb_target_group.arn]
  health_check_type   = "EC2"
  vpc_zone_identifier = [data.aws_ssm_parameter.private-subnet-1.value, data.aws_ssm_parameter.private-subnet-2.value]

  launch_template {
    id      = aws_launch_template.Autoscaling-server.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "Autoscaling-server"
    propagate_at_launch = true
  }
}