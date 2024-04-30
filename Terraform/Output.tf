# # Output configuration details
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
