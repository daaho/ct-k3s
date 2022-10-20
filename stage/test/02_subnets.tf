#--------------------------------------------------------------------------------------------------
#
# Public subnets
#
#--------------------------------------------------------------------------------------------------
resource "aws_subnet" "public-1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.1.0/24"

  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1a"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.2.0/24"

  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1b"
  }
}

resource "aws_subnet" "public-1c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.3.0/24"

  availability_zone       = "eu-central-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1c"
  }
}


#--------------------------------------------------------------------------------------------------
#
# Private subnets
#
#--------------------------------------------------------------------------------------------------
resource "aws_subnet" "private-1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.11.0/24"

  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-1a"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.12.0/24"

  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-1b"
  }
}

resource "aws_subnet" "private-1c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.13.0/24"

  availability_zone       = "eu-central-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-1c"
  }
}

