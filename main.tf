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
