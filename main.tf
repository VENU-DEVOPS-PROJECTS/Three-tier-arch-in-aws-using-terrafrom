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

# Create a private subnet 3 with CIDR block 10.0.3.0/24
resource "aws_subnet" "private_subnet_3" {
  vpc_id     = aws_vpc.threetier-arch-vpc.id
  cidr_block = "${var.priv3_3tier_cidr_block}"
  availability_zone = "${var.sub_3tier_zonea}"
  tags = {
    Name = "private_subnet_3"
  }
}

# Create a private subnet 4 with CIDR block 10.0.4.0/24
resource "aws_subnet" "private_subnet_4" {
  vpc_id     = aws_vpc.threetier-arch-vpc.id
  cidr_block = "${var.priv4_3tier_cidr_block}"
  availability_zone = "${var.sub_3tier_zoneb}"
  tags = {
    Name = "private_subnet_4"
  }
}

# Create a private subnet 5 with CIDR block 10.0.5.0/24
resource "aws_subnet" "private_subnet_5" {
  vpc_id     = aws_vpc.threetier-arch-vpc.id
  cidr_block = "${var.priv5_3tier_cidr_block}"
  availability_zone = "${var.sub_3tier_zonea}"
  tags = {
    Name = "private_subnet_5"
  }
}

# Create a private subnet 6 with CIDR block 10.0.6.0/24
resource "aws_subnet" "private_subnet_6" {
  vpc_id     = aws_vpc.threetier-arch-vpc.id
  cidr_block = "${var.priv6_3tier_cidr_block}"
  availability_zone = "${var.sub_3tier_zoneb}"
  tags = {
    Name = "private_subnet_6"
  }
}

# Create public route table
resource "aws_route_table" "my-public-RT" {
  vpc_id = aws_vpc.threetier-arch-vpc.id
  tags = {
    Name = "my-public-RT"
  }
}

# Adding routes to the public route table
resource "aws_route" "normal-route" {
  route_table_id            = aws_route_table.my-public-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.threetier-arch-igw.id
}

# Associating public subnet 1 to the public route table
resource "aws_route_table_association" "associate-public-subnet-1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.my-public-RT.id
}

# Associating public subnet 2 to the public route table
resource "aws_route_table_association" "associate-public-subnet-1" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.my-public-RT.id
}
