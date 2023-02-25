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
resource "aws_route" "normal-public-route" {
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
resource "aws_route_table_association" "associate-public-subnet-2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.my-public-RT.id
}

# Create elastic ip for NAT GW
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "nat_eip"
  }
}

# Create NAT GW
resource "aws_nat_gateway" "threetier-arch-nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "my-3tier-NAT"
  }
}

# Create private route table
resource "aws_route_table" "my-private-RT" {
  vpc_id = aws_vpc.threetier-arch-vpc.id
  tags = {
    Name = "my-private-RT"
  }
}

# Adding routes to the public route table
resource "aws_route" "normal-private-route" {
  route_table_id            = aws_route_table.my-private-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.threetier-arch-nat_gateway.id
}

# Associating private subnet 3 to the private route table
resource "aws_route_table_association" "associate-private-subnet-3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.my-private-RT.id
}

# Associating private subnet 4 to the private route table
resource "aws_route_table_association" "associate-private-subnet-4" {
  subnet_id      = aws_subnet.private_subnet_4.id
  route_table_id = aws_route_table.my-private-RT.id
}

# Associating private subnet 5 to the private route table
resource "aws_route_table_association" "associate-private-subnet-5" {
  subnet_id      = aws_subnet.private_subnet_5.id
  route_table_id = aws_route_table.my-private-RT.id
}

# Associating private subnet 6 to the private route table
resource "aws_route_table_association" "associate-private-subnet-6" {
  subnet_id      = aws_subnet.private_subnet_6.id
  route_table_id = aws_route_table.my-private-RT.id
}

# Create SG for web tier
resource "aws_security_group" "my3tierweb_sg" {
  name_prefix = "my3tierwebsg"
  description = "web tier security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my3tierwebsg"
  }
}

# Create SG for app tier
resource "aws_security_group" "apptier_sg" {
  name_prefix = "apptiersg"
  description = "app tier security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "apptiersg"
  }
}

# Create launch configuraion template for web tier
resource "aws_launch_configuration" "my-3tier-launch" {
  name_prefix = "my-3tier-launch"
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.my3tierweb_sg.id}"]
  key_name = "T3-key"
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd

              echo "<html><body><h1>Welcome to the web tier!</h1></body></html>" > /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Create launch configuraion template for app tier
resource "aws_launch_configuration" "my-apptier-launch" {
  name_prefix = "my-apptier-launch"
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.apptier_sg.id}"]
  key_name = "T3-key"
  
  user_data = <<-EOF
              #!/bin/bash
              echo $SHELL
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webtier-asg" {
  name_prefix = "webtier-asg"
  launch_configuration = aws_launch_configuration.my-3tier-launch.id
  vpc_zone_identifier = ["${aws_subnet.public_subnet_1.id}", "${aws_subnet.public_subnet_2.id}"]
  min_size = 1
  max_size = 2
  desired_capacity = 1

  tag {
    key = "Name"
    value = "webtier-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "apptier-asg" {
  name_prefix = "apptier-asg"
  launch_configuration = aws_launch_configuration.my-apptier-launch.id
  vpc_zone_identifier = ["${aws_subnet.private_subnet_3.id}", "${aws_subnet.private_subnet_4.id}"]
  min_size = 1
  max_size = 2
  desired_capacity = 1

  tag {
    key = "Name"
    value = "webtier-asg"
    propagate_at_launch = true
  }
}

# Create SG for db tier
resource "aws_security_group" "database_sg" {
  name_prefix = "database_sg"
  description = "db tier security group"
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dbtiersg"
  }
}

resource "aws_db_subnet_group" "database-1_subnet_group" {
  name       = "database-1_subnet_group"
  subnet_ids = toset([aws_subnet.private_subnet_3.id,aws_subnet.private_subnet_4.id])
}

resource "aws_db_instance" "database-1" {
  identifier            = "database-1"
  allocated_storage     = 20
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  name                  = "database-1"
  username              = "admin"
  password              = "admin3339"
  skip_final_snapshot   = true
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.database-1_subnet_group.name
}

output "db_instance_address" {
  value = aws_db_instance.database-1.address
}
