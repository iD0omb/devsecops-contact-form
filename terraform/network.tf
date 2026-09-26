# Availability zones & subnet ranges
# terraform fmt is so cool
locals {
  azs                  = ["ap-southeast-1a", "ap-southeast-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
}

# Virtual Private Cloud
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "dso-vpc" }
}

# Public subnet
resource "aws_subnet" "public" {
  count             = length(local.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = { Name = "dso-public-${local.azs[count.index]}", "kubernetes.io/role/elb" = "1" }
}

# Private Subnet
resource "aws_subnet" "private" {
  count             = length(local.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = { Name = "dso-private-${local.azs[count.index]}", "kubernetes.io/role/internal-elb" = "1" }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "dso-igw" }
}

# Public routing: 0.0.0.0/0 -> Internet Gateway (Make subnet public)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = { Name = "dso-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private routing: 0.0.0.0/0, NAT Outbound only
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = { Name = "dso-private-rt" }
}

resource "aws_route_table_association" "private" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# ---------------- Public IP for the NAT -----------------
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "dso-nat-eip" }
}

# NAT Gateway ($0.059/hour)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags          = { Name = "dso-nat" }

  # The NAT gateway requires the Internet gateway to be up beforehand
  depends_on = [aws_internet_gateway.main]
}

# -----------------------------------------------------------------------