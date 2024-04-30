## Local configurations
// ----------------------------------

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



