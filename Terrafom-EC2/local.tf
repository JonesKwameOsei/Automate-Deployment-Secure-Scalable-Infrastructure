# Local resources Config
//-----------------------------------

locals {
  name          = format("%s-%s", var.name, "vpc")
  short_region  = "euw2"
  resource_name = format("%s-%s", var.name, local.short_region)
}