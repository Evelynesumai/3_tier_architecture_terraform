resource "aws_vpc" "three_tier_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "three_tier_vpc"
  }
}
# Public Subnets1
resource "aws_subnet" "public_subnet_tier_1" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "public_subnet_tier_1"
  }
}
# Public Subnets2
resource "aws_subnet" "public_subnet_tier_2" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.0.0.16/28"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_tier_2"
  }
}

# Private Subnets 
resource "aws_subnet" "private_subnet_tier" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "private_subnet_tier"
  }
}