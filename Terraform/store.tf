// Setting up AWS Systems Manager (SSM) Parameter Store to encrypt sensitive configuration.
// These configurations include byt not limited to: VPC ID, public and private subnet IDs, and the VPC's CIDR block.
// These crucial configurations will be exported as environment variables to configure the EC2 instance.
// -----------------------------------------------------------------------------------------------------------------

# Creating a VPC ID with SSM parameter store. 
# resource "aws_ssm_parameter" "vpc_id" {
#   name  = "${local.aws_ssm_vpc}/vpc_id"
#   type  = "String"
#   value = aws_vpc.vpc_web.id
# }

# # Creating a VPC cidr with SSM parameter store. 
# resource "aws_ssm_parameter" "vpc_cidr" {
#   name  = "${local.aws_ssm_vpc}/vpc_cidr"
#   type  = "String"
#   value = aws_vpc.vpc_web.cidr_block
# }

# # Creating a public subnet IDs with SSM parameter store.
# resource "aws_ssm_parameter" "public_subnet_1_id" {
#   name  = "${local.aws_ssm_public_subnet}/public-subnet-1-id"
#   type  = "String"
#   value = aws_subnet.public-subnet-1.id
# }

# resource "aws_ssm_parameter" "public_subnet_2_id" {
#   name  = "${local.aws_ssm_public_subnet}/public-subnet-2-id"
#   type  = "String"
#   value = aws_subnet.public-subnet-2.id
# }

# # Creating a private subnet IDs with SSM parameter store. 
# resource "aws_ssm_parameter" "private_subnet_1_id" {
#   name  = "${local.aws_ssm_private_subnet}/private-subnet-1-id"
#   type  = "String"
#   value = aws_subnet.private-subnet-1.id
# }

# resource "aws_ssm_parameter" "private_subnet_2_id" {
#   name  = "${local.aws_ssm_private_subnet}/private-subnet-2-id"
#   type  = "String"
#   value = aws_subnet.private-subnet-2.id
# }

# # Creating a Network Gateway ID with SSM parameter store. 
# resource "aws_ssm_parameter" "ngw_id" {
#   name  = "${local.ssm_nat_gateway}/ngw-id"
#   type  = "String"
#   value = aws_nat_gateway.ngw.id
# }

# # Creating a Internet Gateway ID with SSM parameter store. 
# resource "aws_ssm_parameter" "igw_id" {
#   name  = "${local.ssm_int_gateway}/igw-id"
#   type  = "String"
#   value = aws_internet_gateway.ig_web.id
# }

# # Creating a public route table IDs and cidrs with SSM parameter store. 
# resource "aws_ssm_parameter" "public_route_tbl" {
#   name  = "${local.ssm_public_rtb}/public-rtb_id"
#   type  = "String"
#   value = aws_route_table.public.id
# }

# resource "aws_ssm_parameter" "private_route_tbl" {
#   name  = "${local.ssm_private_rtb}/private-rtb_id"
#   type  = "String"
#   value = aws_route_table.private.id
# }

# # Create an SSM parameter for Elastic IP ID
# resource "aws_ssm_parameter" "eip_id" {
#   name  = "${local.ssm_nat_gateway}/eip_id"
#   type  = "String"
#   value = aws_eip.elastic_web.id
# }

# # Create an SSM parameter for storing various Security Groupd IDs
# resource "aws_ssm_parameter" "sg" {
#   name  = "${local.ssm_secgrp}/sg_id"
#   type  = "String"
#   value = aws_security_group.sg_web.id
# }

# resource "aws_ssm_parameter" "alb-sg" {
#   name  = "${local.ssm_secgrp}/alb-sg_id"
#   type  = "String"
#   value = aws_security_group.alb-sg.id
# }

# resource "aws_ssm_parameter" "auto-sg" {
#   name  = "${local.ssm_secgrp}/auto-sg_id"
#   type  = "String"
#   value = aws_security_group.auto-sg.id
# }

# # Create an SSM parameter for storing the Network Interface ID
# # Create an SSM parameter for storing the Network Interface ID
# # resource "aws_ssm_parameter" "nif_id" {
# #   name  = "${local.ssm_network_interface}/nif_id"
# #   type  = "String"
# #   value = aws_network_interface.nic_web.id
# # }