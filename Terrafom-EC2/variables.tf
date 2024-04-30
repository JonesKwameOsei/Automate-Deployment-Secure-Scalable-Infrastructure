################################################################################
# Declaring Variables for Resources
################################################################################

# Set default resource name
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
