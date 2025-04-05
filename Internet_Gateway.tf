# Internet Gateway
resource "aws_internet_gateway" "three_tier_Igw" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = {
    Name = "three_tier_Igw"
  }
}
# elastic ip address for NAT Gateway
resource "aws_eip" "three_tier_nat_gateway_eip" {
  domain = "vpc"
}

# Nat Gateway
resource "aws_nat_gateway" "three_tier_nat_gateway" {
  allocation_id = aws_eip.three_tier_nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet_tier_1.id

  tags = {
    Name = "three_tier_nat_gateway"
  }
  depends_on = [aws_internet_gateway.three_tier_Igw]
}
# Route Table
resource "aws_route_table" "three_tier_web_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id
  tags = {
    Name = "three_tier_web_rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_Igw.id
  }
}

resource "aws_route_table" "three_tier_app_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id
  tags = {
    Name = "three_tier_app_rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.three_tier_nat_gateway.id
  }
}

# Route Table Association
resource "aws_route_table_association" "three_tier_web_rt1" {
  subnet_id      = aws_subnet.public_subnet_tier_1.id
  route_table_id = aws_route_table.three_tier_web_rt.id
}

resource "aws_route_table_association" "three_tier_web_rt2" {
  subnet_id      = aws_subnet.public_subnet_tier_2.id
  route_table_id = aws_route_table.three_tier_web_rt.id
}
