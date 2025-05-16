# Public Subnet A
resource "aws_subnet" "public_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

# Public Subnet C
resource "aws_subnet" "public_c" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_c_cidr
  availability_zone       = var.az_c
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-c"
  }
}

# Private Subnet A
resource "aws_subnet" "private_a" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.az_a

  tags = {
    Name = "private-subnet-a"
  }
}

# Private Subnet C
resource "aws_subnet" "private_c" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_c_cidr
  availability_zone = var.az_c

  tags = {
    Name = "private-subnet-c"
  }
}
