################################################################################
# Declaring Variables for Resources
################################################################################

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
