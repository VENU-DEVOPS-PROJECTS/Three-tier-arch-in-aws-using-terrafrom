# Configure the AWS provider
provider "aws" {
  region = "us-east-2"
}


# Create a new VPC with CIDR block 10.0.0.0/16
resource "aws_vpc" "threetier-arch-vpc" {
  cidr_block = "${var.vpc_cidr_block}"
}
