# Configure the AWS provider
provider "aws" {
  region = "us-east-2"
}


# Create a new VPC with CIDR block 10.0.0.0/16
resource "aws_vpc" "threetier-arch-vpc" {
  cidr_block = "${var.vpc_cidr_block}"
}

# Create an internet gateway and attach it to the VPC created above
resource "aws_internet_gateway" "threetier-arch-igw" {
  vpc_id = aws_vpc.threetier-arch-vpc.id
}

# Create a public subnet 1 with CIDR block 10.0.1.0/24
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.threetier-arch-vpc.id
  cidr_block = "${var.pub1_3tier_cidr_block}"
  availability_zone = "${var.pub1_3tier_zone}"
  
  # Specify that this is a public subnet
  map_public_ip_on_launch = true
}
