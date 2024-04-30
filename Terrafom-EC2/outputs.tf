# Output configuration details for EC2
// The output of this script is a JSON object containing the following information:
// ----------------------------------

# output "key_pair_name" {
#   value = aws_key_pair.nginx_auth.key_name
# }

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

# Output Private IP
# output "web_server_private_ip" {
#   value = aws_instance.ec2_web.private_ip
# }

# # Output Web Server ID
# output "web_server_id" {
#   value = aws_instance.ec2_web.id
# }