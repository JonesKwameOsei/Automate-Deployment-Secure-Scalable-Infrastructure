# Compatibility version constraint
// ----------------------------------

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

# # Configure Default AWS Region tp eu-west-2
# provider "aws" {
#   region = "eu-west-2"
#   alias  = "dev"
# }