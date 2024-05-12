terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Define a variable for system identifier
variable "system_identifier" {
  type    = string
  default = "demo"
}