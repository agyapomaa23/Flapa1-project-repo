# Create VPC
resource "aws_vpc" "prod-rock-vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "prod rock vpc"
  }
}

# Create Internet Gateway and Attach it to VPC
resource "aws_internet_gateway" "test-igw" {
  vpc_id    =  aws_vpc.prod-rock-vpc.id

  tags      = {
    Name    = "test igw"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "test-public-sub1" {
  vpc_id                  =  aws_vpc.prod-rock-vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "test public sub1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "test-public-sub2" {
  vpc_id                  =  aws_vpc.prod-rock-vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "test public sub2"
  }
}

# Create Route Table and Add Public Route
resource "aws_route_table" "test-igw-association" {
  vpc_id       =   aws_vpc.prod-rock-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }

  tags       = {
    Name     = "test igw association"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.test-public-sub1.id
  route_table_id      = aws_route_table.test-igw-association.id
}

# Associate Public Subnet 2 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.test-public-sub2.id
  route_table_id      = aws_route_table.test-igw-association.id
}

# Create Private Subnet 1
resource "aws_subnet" "test-priv-sub1" {
  vpc_id                   =  aws_vpc.prod-rock-vpc.id
  cidr_block               = var.private_subnet_az1_cidr
  availability_zone        = "eu-west-2a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "test priv sub1"
  }
}

# Create Private Subnet 2
resource "aws_subnet" "test-priv-sub2" {
  vpc_id                   =  aws_vpc.prod-rock-vpc.id
  cidr_block               = var.private_subnet_az2_cidr
  availability_zone        = "eu-west-2b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "test priv sub2"
  }
}
