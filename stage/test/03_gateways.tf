#--------------------------------------------------------------------------------------------------
#
# Internet Gateway
#
#--------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "igw-k3s" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-k3s"
  }

}


#--------------------------------------------------------------------------------------------------
#
# NAT Gateway
#
#--------------------------------------------------------------------------------------------------
resource "aws_eip" "eip-private-1a" {
  vpc = true
}

resource "aws_nat_gateway" "ngw-private-1a" {
  allocation_id = aws_eip.eip-private-1a.id
  subnet_id     = aws_subnet.private-1a.id

  tags = {
    Name = "ngw-private-1a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw-k3s]

}
