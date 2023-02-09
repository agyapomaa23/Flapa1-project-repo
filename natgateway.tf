# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az1 
resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc    = true

  tags   = {
    Name = "eip 1"
  }
}


# create nat gateway in public subnet az1
resource "aws_nat_gateway" "test-nat-gateway" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = aws_subnet.test-public-sub1.id

  tags   = {
    Name = "test nat gateway"
  }
  }


# create private route table az1 and add route through nat gateway az1
resource "aws_route_table" "test-nat-association" {
  vpc_id            = aws_vpc.prod-rock-vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.test-nat-gateway.id
  }

  tags   = {
    Name = "test nat association"
  }
}

# associate private subnet az1 with private route table az1
resource "aws_route_table_association" "private-subnet-az1-route-table-association" {
  subnet_id         = aws_subnet.test-priv-sub1.id
  route_table_id    = aws_route_table.test-nat-association.id
}

# associate private subnet az2 with private route table az1
resource "aws_route_table_association" "private-subnet-az2-route-table-association" {
  subnet_id         = aws_subnet.test-priv-sub2.id
  route_table_id    =  aws_route_table.test-nat-association.id
}

