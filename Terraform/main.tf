################################################################################
# Declaring Resources
################################################################################

# Defining VPC
resource "aws_vpc" "vpc_web" {
  cidr_block = var.cidr_block[0]
  tags = {
    Name = "${var.name}-nginx-vpc"
  }
}

# Defining Internet Gateway
resource "aws_internet_gateway" "ig_web" {
  vpc_id = aws_vpc.vpc_web.id
  tags = {
    Name = "${local.resource_name}-igw"
  }
}

# Defining Public and Private Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.vpc_web.id
  cidr_block        = var.cidr_block[1]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${local.resource_name}-Public-Subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.vpc_web.id
  cidr_block        = var.cidr_block[2]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${local.resource_name}-Public-Subnet-2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.vpc_web.id
  cidr_block        = var.cidr_block[3]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${local.resource_name}-Private-Subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.vpc_web.id
  cidr_block        = var.cidr_block[4]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${local.resource_name}-Private-Subnet-1"
  }
}

# Defining Custom Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_web.id

  route {
    cidr_block = var.cidr_block[5]
    gateway_id = aws_internet_gateway.ig_web.id
  }

  tags = {
    Name = "${local.resource_name}-Public_RTA"
  }
}

# Associating route table with public subnets
resource "aws_route_table_association" "rta_public-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "rta_public-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_web.id

  route {
    cidr_block = var.cidr_block[5]
    gateway_id = aws_internet_gateway.ig_web.id
  }
  tags = {
    Name = "${local.resource_name}-Private_RTA"
  }
}

# Associate private route tables wth the private subnets. 
resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private.id
}


# Defining Security group for HTTP, HTTPS and SSH protocols
resource "aws_security_group" "sg_web" {
  name        = "${local.resource_name} Server"
  description = "Allow Web Server Traffic"
  vpc_id      = aws_vpc.vpc_web.id

  ingress {
    description = "HTTP Incoming traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[5]]
  }

  ingress {
    description = "HTTPs Incoming traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[5]]
  }

  ingress {
    description = "SSH Incoming traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[5]]
  }

  egress {
    description = "All Outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block[5]]
  }

  tags = {
    Name = "${local.resource_name}_Security_Group"
  }

}


# Create Security Group for the Application Load Balancer
# terraform aws create security group
resource "aws_security_group" "alb-sg" {
  name        = "ALB-Security-Group"
  description = "Enable HTTP/HTTPS access on Port 80/443"
  vpc_id      = aws_vpc.vpc_web.id
  depends_on  = [aws_vpc.vpc_web]
  ingress {
    description = "HTTP Incoming traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[5]]
  }

  ingress {
    description = "HTTPs Incoming traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[5]]
  }

  ingress {
    description = "SSH Incoming traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[5]]
  }

  egress {
    description = "All Outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block[5]]
  }
  tags = {
    Name = "${local.resource_name}_Alb-SG"
  }
}


# Create Security Group for the auto scaling group
resource "aws_security_group" "auto-sg" {
  name        = "Auto Sec Group"
  description = "Enable HTTP/HTTPS access on Port 80/443"
  vpc_id      = aws_vpc.vpc_web.id
  depends_on  = [aws_vpc.vpc_web]
ingress {
    description = "HTTP Incoming traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[5]]
  }

  ingress {
    description = "HTTPs Incoming traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[5]]
  }

  ingress {
    description = "SSH Incoming traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[5]]
  }

  egress {
    description = "All Outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block[5]]
  }

   tags = {
    Name = "${local.resource_name}_Auto-SG"
  }
}


# Assinging elastic IP to be attached to the NAT Gateway
resource "aws_eip" "elastic_web" {
domain      = "vpc"
  tags = {
    Name = "${local.resource_name}-Elastic_IP"
  }
}

# Create a NAT gateway and attach it with Elastic IP
resource "aws_nat_gateway" "ngw" {    
  allocation_id = aws_eip.elastic_web.id 
  subnet_id     = aws_subnet.public-subnet-2.id
  tags = {
    Name = "${local.resource_name}-Ngw"
  }
}


################################################################################
# Declaring Resources for EC2 
################################################################################

# Create instance SSH key pair
# resource "aws_key_pair" "nginx_auth" {
#   key_name   = var.key_name
#   public_key = file("C:/Users/KWAME/.ssh/id_rsa")
# }

# Create Instance. 
# Defining EC2 instance
# resource "aws_instance" "ec2_web" {
#   ami               = data.aws_ami.ubuntu_latest.id
#   instance_type     = var.instance_type
#   vpc_security_group_ids = [data.aws_ssm_parameter.sg.value]
#   subnet_id = data.aws_ssm_parameter.private-subnet-2.value
#   availability_zone = var.availability_zones[1]
#   user_data         = file("userdata.tpl")
#   associate_public_ip_address = true
#   root_block_device {
#     volume_size = var.root_size
#   }
#   tags = {
#     Name = "${var.name}-Nginx-Server"
#   }
# }

# # # create Application balancer
# resource "aws_lb" "application_load_balancer" {
#   name                       = "${local.resource_name}-alb"
#   internal                   = false
#   load_balancer_type         = "application"
#   security_groups            = [data.aws_ssm_parameter.alb_sg.value]
#   subnets                    = [for subnet in [data.aws_ssm_parameter.public-subnet-1.value, data.aws_ssm_parameter.public-subnet-2.value] : subnet]
#   enable_deletion_protection = false

#   tags = {
#     Name = "${local.resource_name}-ALB"
#   }
# }

# # create target group and attach to the instance 
# resource "aws_lb_target_group" "alb_target_group" {
#   name     = "${local.resource_name}-Alb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = data.aws_ssm_parameter.vpc_id.value

#   health_check {
#     path                = "/healthz"
#     interval            = 30
#     port                = var.http_port
#     timeout             = 5
#     unhealthy_threshold = 2
#     healthy_threshold   = 4
#   }
#   depends_on = [aws_lb.application_load_balancer]
#   tags = {
#     Name = "${local.resource_name}-TG"
#   }
# }

# # create a listener on port 80 with redirect action
# resource "aws_lb_listener" "alb_http_listener" {
#   load_balancer_arn = aws_lb.application_load_balancer.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = var.https_port
#       protocol    = var.protocol_tg
#       status_code = var.status_tg
#     }
#   }
# }

# resource "aws_launch_template" "Autoscaling-server" {
#   name_prefix            = "${local.resource_name}-lunch-template"
#   image_id               = data.aws_ami.ubuntu_latest.image_id
#   instance_type          = var.instance_type
#   key_name               = var.key_name
#   vpc_security_group_ids = [data.aws_ssm_parameter.auto_sg.value]
# }

# # Attach target groups to alb
# resource "aws_lb_target_group_attachment" "ec2-instances1" {
#   target_group_arn = aws_lb_target_group.alb_target_group.arn
#   target_id        = aws_instance.ec2_web.id
#   port             = 80
# }

# # Create Auto Scaling Group
# resource "aws_autoscaling_group" "Auto-sg" {
#   name                = "Nginx-Autoscaling group"
#   desired_capacity    = 1
#   max_size            = 2
#   min_size            = 1
#   force_delete        = true
#   target_group_arns   = [aws_lb_target_group.alb_target_group.arn]
#   health_check_type   = "EC2"
#   vpc_zone_identifier = [data.aws_ssm_parameter.private-subnet-1.value, data.aws_ssm_parameter.private-subnet-2.value]

#   launch_template {
#     id      = aws_launch_template.Autoscaling-server.id
#     version = "$Latest"
#   }
#   tag {
#     key                 = "Name"
#     value               = "Autoscaling-server"
#     propagate_at_launch = true
#   }
# }
