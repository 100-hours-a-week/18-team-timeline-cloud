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

# Private Subnet A Front
resource "aws_subnet" "private_a_front" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_a_front_cidr
  availability_zone = var.az_a

  tags = {
    Name = "private-subnet-a-front"
  }
}

# Private Subnet C Front
resource "aws_subnet" "private_c_front" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_c_front_cidr
  availability_zone = var.az_c

  tags = {
    Name = "private-subnet-c-front"
  }
}


# Private Subnet A Back
resource "aws_subnet" "private_a_back" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_a_back_cidr
  availability_zone = var.az_a

  tags = {
    Name = "private-subnet-a-back"
  }
}

# Private Subnet C Back
resource "aws_subnet" "private_c_back" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_c_back_cidr
  availability_zone = var.az_c

  tags = {
    Name = "private-subnet-c-back"
  }
}

# Private Subnet A DB
resource "aws_subnet" "private_a_db" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_a_db_cidr
  availability_zone = var.az_a

  tags = {
    Name = "private-subnet-a-db"
  }
}

# Private Subnet C DB
resource "aws_subnet" "private_c_db" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_c_db_cidr
  availability_zone = var.az_c

  tags = {
    Name = "private-subnet-c-db"
  }
}
