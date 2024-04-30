# Automate-Deployment-Secure-Scalable-Infrastructure
Automate the deployment of Secure and Scalable AWS Infrastructure with Terraform

## Overview
This project main objective is to leverage **Terraform** to **automate** the deployment of **a secured** and **scalable** infrastrcuture in **AWS environment**. This project encapsulates configuring **a Virtual Private Cloud (VPC)** and its components as well as deploying an **Amazon Elastic Compute Cloud (EC2) Instance** within the vpc to serve an **Nginx** application. 

### Deploying Application with Terraform. 
In my previous [project](https://github.com/JonesKwameOsei/Terraform), **terraform** was used to build and managed infrastructure. However, there were not enough **security** measures taken to **secure sensitive details** about the infrasture built. As **Cloud Engineers** an important mandate is to **obfuscate** infrastructure's sensitive information using several techniques including:
Cloud engineers can obfuscate infrastructure's sensitive information using several techniques:

1. **Encryption**: Encrypting sensitive data at **rest** and in **transit** using strong encryption algorithms can help protect the data from **unauthorised access**.

2. **Access Control**: Implementing **strict access control measures** such as using **IAM (Identity and Access Management)** **policies**, **role-based access control**, and **least privilege principles** to ensure that only authorised personnel can access sensitive information.

3. **Secrets Management**: Storing sensitive information such as API keys, passwords, and other credentials in a secure and centralized location using a secrets management service. This helps in controlling access to sensitive data and provides an audit trail of who accessed the information.

4. **Masking and Redaction**: Masking or redacting sensitive information in logs, error messages, and other system outputs to prevent exposure of sensitive data to unauthorized users.

5. **Tokenization**: Using tokenization to replace sensitive data with non-sensitive equivalent tokens. This allows applications to operate on the data without exposing the actual sensitive information.

6. **Network Security**: Implementing network security measures such as firewalls, network segmentation, and VPNs to protect sensitive information from unauthorized access.

7. **Secure Configuration Management**: Following **best practices** for **secure configuration management** to ensure that sensitive information is not inadvertently exposed through misconfigurations.<p>

Implementing the above techniques, cloud engineers can effectively obfuscate infrastructure's sensitive information and reduce the risk of unauthorized access and data breaches.<p>

This project utilises **Terraform** to sucure infrastructure by ensuring all configuration are managed securely. 

### Clone the Repository into Local System:
**Cloning** a repository and deploying infrastructure using a **version control system** offers several benefits:
- **Reproducibility**: By storing infrastructure code in a version control system, it becomes easier to reproduce and deploy the exact same infrastructure in multiple environments. This helps in maintaining consistency across development, testing, and production environments.
-  **Versioning**: Version control systems allow for tracking changes to infrastructure code over time. This enables teams to understand how the infrastructure has evolved, revert to previous versions if necessary, and review the history of changes made to the infrastructure.
- **Change Management**: Using version control for infrastructure code enables better change management practices. Changes can be proposed, reviewed, and approved through pull requests or similar mechanisms, providing visibility and control over modifications to the infrastructure.
- **Automation**: Integration with continuous integration/continuous deployment (CI/CD) pipelines becomes easier when infrastructure code is stored in a version control system. This allows for automated testing, validation, and deployment of infrastructure changes.<p>

To clone the remote repo:
1. In the **VScode** terminal, run:
```
git clone <repo url>
```
2. Create an local directory
```
mkdir Terraform

mkdir -p .github/workflows
```
3. Create files in the **Terraform** folder as the configuration requires.

## Virtual Private Cloud (VPC) Confidguration
We will create a **VPC** with:
1. two **private** and two **public** **subnets** to ensure a segregated and efficient network topology.
2. Incorporate a minimum of one **NAT Gateway** and an **Internet Gateway** to enable secure internet connectivity for your applications.
3. **Route tables**, one **Private** and **Public Route**, correctly to effectively manage network traffic within the VPC. Alos, designing route tables thoughtfully to route traffic accurately between subnets, the internet, and other services.

### Creating VPC Resources
1. Define the variables **vpc** and its components.
Create a folder called, vpc. In the vpc folder, create a file called **variables.tf** with the following configuration:
```
########################################################################################################################
# Declaring Variables for Resources
########################################################################################################################

# set variables for VPC name
variable "name" {
  description = "The instance name as prefix to be attached to almost every resource name"
  type        = string
  default     = "jones"
}

# set variables VPC 
variable "region" {
  default     = ["eu-west-2"]
  description = "AWS Region for deployment"
  type        = list(any)
}

# variables sets for the subnets within AZs. 
variable "availability_zones" {
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  description = "AWS region az for subnet deployment"
  type        = list(string)
}

// Varibles for vpc configurations
variable "cidr_block" {
  type        = list(string)
  default     = ["10.0.0.0/16", "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "0.0.0.0/0"]
  description = "CIDR blocks for VPC, subnet and security group"
}

# variable "private_route_cidr" {
#   description = "The CIDR range to be used for the private route table"
#   type        = string
#   default     = "0.0.0.0/0"
# }

// VPC Variables for working envs
variable "servers" {
  default = ["dev", "staging", "prod"]
  type    = list(any)
}

//  VPC-SEC group ports Variables
variable "ssh_port" {
  description = "The port for SSH connections"
  type        = number
  default     = 22 // To allow SSH connections
}

// variables for inbound  rules on security groups
variable "https_port" {
  description = "The port for HTTPS connections"
  type        = number
  default     = 443
}

// variables for inbound  rules on security groups
variable "http_port" {
  description = "The port for HTTPS connections"
  type        = number
  default     = 80
}

// Allow traffic from anywhere (world) to these IPs and Port
variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks for ingress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"] // This CIDR blocks (allowing traffic from anywhere)
}

// variables for outbound  rules on security groups
variable "egress_ports" {
  description = "List of egress ports to be opened"
  type        = number
  default     = 0 // egress ports (allowing outbound traffic on ports 0, 80, and 443)
}

variable "egress_cidr_blocks" {
  description = "List of CIDR blocks for egress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"] // CIDR blocks (allowing traffic to anywhere)
}

variable "private_ips" {
  type        = list(string)
  default     = ["10.0.0.50"]
  description = "Private IP for EC2 instance"
}

# set variables VPC 
variable "region" {
  default     = ["eu-west-2"]
  description = "AWS Region for deployment"
  type        = list(any)
}

# variables sets for the subnets within AZs. 
variable "availability_zones" {
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  description = "AWS region az for subnet deployment"
  type        = list(string)
}

# Set app server purpose
variable "instance_type" {
  type = string
  default = "t2.micro"
}


// VPC Variables for working envs
variable "servers" {
  default = ["dev", "staging", "prod"]
  type    = list(any)
}

//  VPC-SEC group ports Variables
variable "ssh_port" {
  description = "The port for SSH connections"
  type        = number
  default     = 22 // To allow SSH connections
}
// variables for inbound  rules on security groups
variable "https_port" {
  description = "The port for HTTPS connections"
  type        = number
  default     = 443
}

// variables for inbound  rules on security groups
variable "http_port" {
  description = "The port for HTTP connections"
  type        = number
  default     = 80
}

# Variable to set the target group protocol
variable "protocol_tg" {
  type    = string
  default = "HTTP"
}

variable "status_tg" {
  type    = string
  default = "HTTP_301"
}

# Variable for user data script
variable "user_data_script" {
  type    = string
  default = "user_data.sh"
}

// Allow traffic from anywhere (world) to these IPs and Port
variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks for ingress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"] // This CIDR blocks (allowing traffic from anywhere)
}

// variables for inbound  rules on security groups
variable "allow_ports" {
  description = "The port for all connections"
  type        = number
  default     = 0
}

// variables for outbound  rules on security groups
variable "egress_ports" {
  description = "List of egress ports to be opened"
  type        = list(number)
  default     = [0, 80, 443] // egress ports (allowing outbound traffic on ports 0, 80, and 443)
}

variable "egress_cidr_blocks" {
  description = "List of CIDR blocks for egress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"] // Example CIDR blocks (allowing traffic to anywhere)
}

variable "key_name" {
  description = "ssh key name"
  type        = string
  default     = "id_rsa.pub"
}

variable "root_size" {
  type        = number
  default     = 9
  description = "Size of the root volume"
}
```
In order not to **hard-code** values in our **configuration**, we can include **variables to make the configuration more dynamic and secured. It adds another level of sucurity to sensitive information. 

2. Create a file called **local.tf** with these configuration:
```
########################################################################################################################
# Declaring Local resource configuration
########################################################################################################################

locals {
  name                   = format("%s-%s", var.name, "vpc")
  short_region           = "euw2"
  resource_name          = format("%s-%s", var.name, local.short_region)
  aws_ssm_vpc            = format("/%s/%s/%s", var.name, local.short_region, "vpc")
  aws_ssm_public_subnet  = format("/%s/%s/%s", var.name, local.short_region, "public-subnets")
  aws_ssm_private_subnet = format("/%s/%s/%s", var.name, local.short_region, "private-subnets")
  ssm_int_gateway        = format("/%s/%s/%s", var.name, local.short_region, "igw")
  ssm_nat_gateway        = format("/%s/%s/%s", var.name, local.short_region, "ngw")
  ssm_secgrp             = format("/%s/%s/%s", var.name, local.short_region, "secgrp")
  ssm_private_rtb        = format("/%s/%s/%s", var.name, local.short_region, "private-rtb")
  ssm_public_rtb         = format("/%s/%s/%s", var.name, local.short_region, "public-rtb")
  ssm_public_route_cidr  = format("/%s/%s/%s", var.name, local.short_region, "public-route-cidr")
  ssm_private_route_cidr = format("/%s/%s/%s", var.name, local.short_region, "private-route-cidr")
  ssm_network_interface  = format("/%s/%s/%s", var.name, local.short_region, "nif")
}
```
These resource names are to used globally in the configuration.

3. Create a file called **main.tf** with these resources configuration:
```
########################################################################################################################
# Declaring Resources
########################################################################################################################

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
vpc      = true
  tags = {
    Name = "${local.resource_name}-Elastic_IP"
  }
}

# Create a NAT gateway and attach it with Elastic IP
resource "aws_nat_gateway" "ngw" {    
  allocation_id = aws_eip.elastic_web.id 
  subnet_id     = aws_subnet.public-subnet-2.id
  tags = {
    Name = "${local.resource_name}-ngw"
  }
}

################################################################################
# Declaring Resources for EC2 
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
```
4. **Output vpc** configuration: Create a new file under the vpc folder called **outputs.tf** with the following configuration.
```
########################################################################################################################
# VPC Outputs Configuration
########################################################################################################################
output "vpc_id" {
  value = aws_vpc.vpc_web.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc_web.cidr_block
}

# Output Public IP
output "web_server_public_ip" {
  value = aws_eip.elastic_web.public_ip
}

output "public_ipv4_address" {
  value = aws_instance.ec2_web.public_ip
}

# Output Private IP
output "web_server_private_ip" {
  value = aws_instance.ec2_web.private_ip
}

# Output Web Server ID
output "web_server_id" {
  value = aws_instance.ec2_web.id
}

# Output AMI Image Name
output "ami_name" {
  value = data.aws_ami.ubuntu_latest
}
```
The output of this script is a JSON object containing the **vpc id**, **vpc cidr block and the **elastic ip address**. **Terraform output** can be used to connect Terraform projects with other parts of an infrastructure, or with other Terraform projects.  
5. **Obsfucating** Resources with AWS Systems Manager (SSM) Parameter Store: We will utilise AWS Systems Manager (SSM) Parameter Store to **secure**, **export** crucial configurations such as the **VPC ID**, **public and private subnet IDs, and the VPC's CIDR block as well the security groups**.<p>
Under the **vpc** folder, create a file called **store.tf** and add the following configuration.
```
########################################################################################################################
# Setting up AWS Systems Manager (SSM) Parameter Store to encrypt sensitive configuration.
########################################################################################################################

# Creating a VPC ID with SSM parameter store. 
resource "aws_ssm_parameter" "vpc_id" {
  name  = "${local.aws_ssm_vpc}/vpc_id"
  type  = "String"
  value = aws_vpc.vpc_web.id
}

# Creating a VPC cidr with SSM parameter store. 
resource "aws_ssm_parameter" "vpc_cidr" {
  name  = "${local.aws_ssm_vpc}/vpc_cidr"
  type  = "String"
  value = aws_vpc.vpc_web.cidr_block
}

# Creating a public subnet IDs with SSM parameter store.
resource "aws_ssm_parameter" "public_subnet_1_id" {
  name  = "${local.aws_ssm_public_subnet}/public-subnet-1-id"
  type  = "String"
  value = aws_subnet.public-subnet-1.id
}

resource "aws_ssm_parameter" "public_subnet_2_id" {
  name  = "${local.aws_ssm_public_subnet}/public-subnet-2-id"
  type  = "String"
  value = aws_subnet.public-subnet-2.id
}

# Creating a private subnet IDs with SSM parameter store. 
resource "aws_ssm_parameter" "private_subnet_1_id" {
  name  = "${local.aws_ssm_private_subnet}/private-subnet-1-id"
  type  = "String"
  value = aws_subnet.private-subnet-1.id
}

resource "aws_ssm_parameter" "private_subnet_2_id" {
  name  = "${local.aws_ssm_private_subnet}/private-subnet-2-id"
  type  = "String"
  value = aws_subnet.private-subnet-2.id
}

# Creating a Network Gateway ID with SSM parameter store. 
resource "aws_ssm_parameter" "ngw_id" {
  name  = "${local.ssm_nat_gateway}/ngw-id"
  type  = "String"
  value = aws_nat_gateway.ngw.id
}

# Creating a Internet Gateway ID with SSM parameter store. 
resource "aws_ssm_parameter" "igw_id" {
  name  = "${local.ssm_int_gateway}/igw-id"
  type  = "String"
  value = aws_internet_gateway.ig_web.id
}

# Creating a public route table IDs and cidrs with SSM parameter store. 
resource "aws_ssm_parameter" "public_route_tbl" {
  name  = "${local.ssm_public_rtb}/public-rtb_id"
  type  = "String"
  value = aws_route_table.public.id
}

resource "aws_ssm_parameter" "private_route_tbl" {
  name  = "${local.ssm_private_rtb}/private-rtb_id"
  type  = "String"
  value = aws_route_table.private.id
}

# Create an SSM parameter for Elastic IP ID
resource "aws_ssm_parameter" "eip_id" {
  name  = "${local.ssm_nat_gateway}/eip_id"
  type  = "String"
  value = aws_eip.elastic_web.id
}

# Create an SSM parameter for storing various Security Groupd IDs
resource "aws_ssm_parameter" "sg" {
  name  = "${local.ssm_secgrp}/sg_id"
  type  = "String"
  value = aws_security_group.sg_web.id
}

resource "aws_ssm_parameter" "alb-sg" {
  name  = "${local.ssm_secgrp}/alb-sg_id"
  type  = "String"
  value = aws_security_group.alb-sg.id
}

resource "aws_ssm_parameter" "auto-sg" {
  name  = "${local.ssm_secgrp}/auto-sg_id"
  type  = "String"
  value = aws_security_group.auto-sg.id
}
```
6. Next, we will add a **Terraform Provider** configuration. Create a file named **provider.tf** under the **vpc** folder.
```
########################################################################################################################
# Terraform Provider and Compatibility version constraint.
########################################################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60.0" # The tilde ensures that the version is compatible with 4.60.0
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  alias  = "dev"
}

provider "aws" {
  region = "us-east-1"
  alias  = "prod"
}
```
The **Terraform Block** in the configuration above block contains **Terraform settings**, including the **required providers** Terraform will use to provision the infrastructure configured.

## Build the Infrastructure
Having configured the infrastructure, we must run some **Terraform commands** to build the infrastructure.
1. Initialise the **vpc** directory: Since we have created a new configuration, we need to initialise the directory with:
```
terraform init
```
This command enables Terraform to downloads and installs the providers defined in the configuration, which in this case is the **aws provider**. to learn more, visit my [Terraform-Docker-Nginx Project](https://github.com/JonesKwameOsei/Terraform-Docker-Nginx).<p>

2. Format the configuration files: It a **best practice** to use a consistent formatting in all of the the configuration files. For this reason, run:
```
terraform fmt
```
The commmand automatically updates the configurations in the **vpc** directory for **readability** and **consistency**. 

Here is a condensed version of the text in English:

## Code Deployment with GitHub Actions

This project uses a GitHub Actions workflow and **pipeline** to automate the code deployment process. 
1. Create the action.yaml wokflows file: The workflow consists of the following steps:
- Checkout the repository to get the code.
- Set up the necessary Terraform version and Azure provider.
- Run `terraform init` to initialize the working directory.
- Run `terraform validate` to check the configuration syntax and validity.
- Run `terraform apply` to deploy the infrastructure changes.

#### Dealing with Dependant Workflow Pipelines Actions
To run two separate GitHub Actions workflows for creating a VPC and an EC2 instance without errors, it is recommended to ensure that they do not interfere with each other and that any dependencies between them are properly managed. We can achieve this by:

- **Creating Separate Workflows**: Create separate workflow files for creating the VPC and the EC2 instance, e.g., vpc.yml and ec2.yml.

- **Dependency Management**: If the workflow for creating the EC2 instance depends on the previously created VPC, ensure that the VPC creation workflow completes successfully before triggering the EC2 instance workflow. This can be achieved by using **job dependencies** or **by triggering the EC2 instance workflow as a subsequent step in the VPC workflow**.

- Resource Naming: Ensure that the resources created by one workflow do not conflict with the resources created by the other workflow (e.g., security groups, subnets). Use unique names or identifiers for the resources created by each workflow.

- AWS Credentials: Ensure that both workflows have access to the necessary AWS credentials (access key and secret key) to interact with the AWS services. We can store these credentials as GitHub secrets and use them in your workflow files.

- Error Handling: Implement error handling and retries in the workflows to handle transient errors or failures. Use conditional statements and try/catch blocks for this purpose.<p.

These workflows eliminate the need for manual command-line deployment, making the process more efficient and reliable. We will configure the workflows with options as to **apply** the plan or **destroy** the infrastructure after deployment. It configured like this:

```
name: Deploy VPC

on:
  workflow_dispatch:
    inputs:
      terraform_action:
        type: choice
        description: select terraform action
        options:
        - apply
        - destroy
        required: true
  push:
    branches:
      - main

jobs:
  deploy_vpc:
    name: Terraform Deploy VPC-Resources
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: Terraform

    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

    steps:
    - name: Checkout Repo
      uses: actions/checkout@v4

    - name: Terraform init 
      run: terraform init 
    
    - name: Check if VPC exists
      id: check_vpc
      run: |
        if terraform state show aws_vpc.my_vpc >/dev/null 2>&1; then
          echo "::set-output name=vpc_exists::true"
        else
          echo "::set-output name=vpc_exists::false"
        fi
      
    - name: Terraform Validate
      run: terraform validate
          
    - name: Terraform Plan 
      run: terraform plan 
        
    - name: Terraform Apply
      if: ${{ github.event.inputs.terraform_action == 'apply' && steps.check_vpc.outputs.vpc_exists != 'true' }}
      run: terraform apply --auto-approve 

    - name: Terraform Destroy
      if: ${{ github.event.inputs.terraform_action == 'destroy' && steps.check_vpc.outputs.vpc_exists == 'true' }}
      run: terraform destroy --auto-approve  

  trigger_ec2_workflow:
    needs: deploy_vpc
    runs-on: ubuntu-latest
    steps:
    - name: Trigger EC2 Workflow
      uses: actions/github-script@0.10.7
      with:
        script: |
          const { data: workflows } = await github.actions.listRepoWorkflows({
            owner: context.repo.owner,
            repo: context.repo.repo
          });

          const ec2Workflow = workflows.workflows.find(workflow => workflow.name === "Deploy EC2 Instance");
          if (ec2Workflow) {
            await github.actions.createWorkflowDispatch({
              owner: context.repo.owner,
              repo: context.repo.repo,
              workflow_id: ec2Workflow.id
            });
          }

```
```
name: Deploy EC2 Instance

on:
  workflow_run:
    workflows: ["Deploy VPC"]
    types:
      - completed
  workflow_dispatch:
    inputs:
      terraform_action:
        type: choice
        description: select terraform action
        options:
        - apply
        - destroy
        required: true

jobs:
  deploy_ec2:
    name: Terraform Deploy EC2 Instance
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: Terraform-EC2

    steps:
    - name: Checkout Repo
      uses: actions/checkout@v4

    - name: Terraform init 
      run: terraform init 
    
    - name: Check if VPC exists
      id: check_vpc
      run: |
        if terraform state show aws_vpc.my_vpc >/dev/null 2>&1; then
          echo "::set-output name=vpc_exists::true"
        else
          echo "::set-output name=vpc_exists::false"
        fi
      
    - name: Terraform Validate
      run: terraform validate
          
    - name: Terraform Plan 
      run: terraform plan 
        
    - name: Terraform Apply
      if: ${{ github.event.inputs.terraform_action == 'apply' && steps.check_vpc.outputs.vpc_exists != 'true' }}
      run: terraform apply --auto-approve 

    - name: Terraform Destroy
      if: ${{ github.event.inputs.terraform_action == 'destroy' && steps.check_vpc.outputs.vpc_exists == 'true' }}
      run: terraform destroy --auto-approve  
```
2. Create a new branch to push changes into the main repo branch
```
git checkout -b deployNginxWebapp
```
3. Add configuration files and workflow action yaml file
```
git add .
```
4. Check the files modified
```
git status
```
5. Commit the changes to a staging area
```
git commit -m "Added configuration files" 
```
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/96f5454f-7389-4f55-bbd4-0b4015ce9c20)<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/21f07ddf-d4cc-45bd-b027-7c18826dbfcd)<p>

6. Push the changes, Create and merge pull request <p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/30b19eea-7826-4a87-826c-9f88eaf0e0e1)<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/5829bdc0-764a-4dba-8e81-5ce280d6e282)<p>

The GitHub pipeline action has run and execute the paln command. We need to apply the plan by selecting the option **Apply**.<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/6b3ff47e-1ab7-4b8b-9a62-b9e8a890bb3d)<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/16f60b57-954b-44e0-894f-45c58e5e2951)<p>

Select workflow option, **Apply** and run it. <p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/281e736b-0479-44d5-84a8-07dbef84e013)<p>

![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/9674c840-f5b2-4978-b12d-d2fe43d7f202)<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/28322412-a732-4a20-b83f-3465edfdf3d1)<p>

We can confirm in the AWS management console if the VPC resources and details have been created.<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/2363c674-993a-464d-bd54-9b3b92a5bb3c)<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/907f4eb2-f660-49b4-8730-750922ee6afa)<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/1b5baa78-2690-4b45-bd8a-9ed8409e0aa9)<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/a8a0a072-5116-4658-ab71-22cd1db6a920)<p>

SSmPaameter Store:<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/4587c0d6-f961-4b30-aa7d-59eca767ab25)<p>

## Create EC2 Instance for the Nginx Server with GitHub Actions Pipeline
Having created the **VPC** resources and stored the details in the **ssm parameter store**, we can create the **EC2 instance** by:
1. Uncomment the EC2 resouce, data and out blocks.
2. Push and merge the changes to trigger the ppipeline actions. <p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/46c2009c-b8bf-421c-bb6b-d5abfb434157)<p>
Merged pull request.<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/f7c44936-2f48-49c0-bccb-b9d8edc666cd)<p>
Pipeline actions running.<p>
![image](https://github.com/JonesKwameOsei/Automate-Deployment-Secure-Scalable-Infrastructure/assets/81886509/011f86e1-e17f-4912-b6fe-c999355da8c8)





















