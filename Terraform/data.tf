# # EC2 instance data configurations
# # Inport const ec2InstanceDataConfigurations:
# // -------------------------------------------

# # Fetch the Latest Ubuntu AMI
# data "aws_ami" "ubuntu_latest" {
#   most_recent = true
#   owners      = ["099720109477"] # Canonical

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# // Referencing resources from ssm parameter store
# data "aws_ssm_parameter" "vpc_id" {
#   name = "/jones/euw2/vpc/vpc_id"
# }

# data "aws_ssm_parameter" "vpc_cidr" {
#   name = "/jones/euw2/vpc/vpc_cidr"
# }

# data "aws_ssm_parameter" "sg" {
#   name = "/jones/euw2/secgrp/sg_id"
# }

# data "aws_ssm_parameter" "auto_sg" {
#   name = "/jones/euw2/secgrp/auto-sg_id"
# }

# data "aws_ssm_parameter" "alb_sg" {
#   name = "/jones/euw2/secgrp/alb-sg_id"
# }

# data "aws_ssm_parameter" "private-subnet-1" {
#   name = "/jones/euw2/private-subnets/private-subnet-1-id"
# }

# data "aws_ssm_parameter" "private-subnet-2" {
#   name = "/jones/euw2/private-subnets/private-subnet-2-id"
# }

# data "aws_ssm_parameter" "public-subnet-1" {
#   name = "/jones/euw2/public-subnets/public-subnet-1-id"
# }

# data "aws_ssm_parameter" "public-subnet-2" {
#   name = "/jones/euw2/public-subnets/public-subnet-2-id" //  using the ID of the second existing subnet from ssm parameter store
# }

# data "template_file" "userdata" {
#   template = filebase64("${path.module}/userdata.tpl")
# }



