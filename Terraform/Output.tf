# Output configuration details
// The output of this script is a JSON object containing the following information:
// ----------------------------------

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

# output "public_ipv4_address" {
#   value = aws_instance.ec2_web.public_ip
# }

# # Output Private IP
# output "web_server_private_ip" {
#   value = aws_instance.ec2_web.private_ip
# }

# # Output Web Server ID
# output "web_server_id" {
#   value = aws_instance.ec2_web.id
# }

# # Output AMI Image Name
# output "ami_name" {
#   value = data.aws_ami.ubuntu_latest
# }
