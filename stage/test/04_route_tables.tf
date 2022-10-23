#--------------------------------------------------------------------------------------------------
#
# Route Tables Public subnets
#
#--------------------------------------------------------------------------------------------------

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "rt-public"
  }
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.rt-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-k3s.id
}

data "aws_subnets" "all-public-subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
  tags = {
    Name = "*public*"
  }
}

output "all-public-subnets" {
  value = data.aws_subnets.all-public-subnets
}

output "all-public-subnet-ids" {
  value = data.aws_subnets.all-public-subnets.ids
}

# Route table association with public subnets
resource "aws_route_table_association" "public-subnets" {
  count          = length(data.aws_subnets.all-public-subnets.ids)
  subnet_id      = data.aws_subnets.all-public-subnets.ids[count.index]
  route_table_id = aws_route_table.rt-public.id
}


#--------------------------------------------------------------------------------------------------
#
# Route Tables Private subnets
#
#--------------------------------------------------------------------------------------------------

resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "rt-private"
  }
}

resource "aws_route" "nat-gw" {
  route_table_id         = aws_route_table.rt-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw-public-1a.id
}

data "aws_subnets" "all-private-subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
  tags = {
    Name = "*private*"
  }
}

output "all-private-subnets" {
  value = data.aws_subnets.all-private-subnets
}

output "all-private-subnet-ids" {
  value = data.aws_subnets.all-private-subnets.ids
}

# Route table association with private subnets
resource "aws_route_table_association" "private-subnets" {
  count          = length(data.aws_subnets.all-private-subnets.ids)
  subnet_id      = data.aws_subnets.all-private-subnets.ids[count.index]
  route_table_id = aws_route_table.rt-private.id
}
