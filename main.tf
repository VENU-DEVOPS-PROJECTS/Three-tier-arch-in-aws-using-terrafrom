# Configure the AWS provider
provider "aws" {
  region = "${var.region}"
}


# Create a new VPC with CIDR block 10.0.0.0/16
resource "aws_vpc" "threetier-arch-vpc" {
  cidr_block = "${var.vpc_cidr_block}"
  tags = {
    Name = "threetier-arch-vpc"
  }
}

# Create an internet gateway and attach it to the VPC created above
resource "aws_internet_gateway" "threetier-arch-igw" {
  vpc_id = aws_vpc.threetier-arch-vpc.id
  tags = {
    Name = "threetier-arch-igw"
  }
}

# Create a public subnet 1 with CIDR block 10.0.1.0/24
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.threetier-arch-vpc.id
  cidr_block = "${var.pub1_3tier_cidr_block}"
  availability_zone = "${var.sub_3tier_zonea}"
  tags = {
    Name = "public_subnet_1"
  }
  # Specify that this is a public subnet
  map_public_ip_on_launch = true
}

# Create a public subnet 2 with CIDR block 10.0.2.0/24
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.threetier-arch-vpc.id
  cidr_block = "${var.pub2_3tier_cidr_block}"
  availability_zone = "${var.sub_3tier_zoneb}"
  tags = {
    Name = "public_subnet_2"
  }
  # Specify that this is a public subnet
  map_public_ip_on_launch = true
}
