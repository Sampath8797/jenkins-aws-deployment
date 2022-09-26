# Fetch AZs in the current region
data "aws_availability_zones" "available" {}

#vpc for the web application
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = false
  tags = {
    Name        = "${var.app_name}-${var.env_name}-vpc"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

#Creating 2 Public subnet for VPC, each in differen AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1 + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-${var.env_name}-public"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

#Creating 2 Private subnet for VPC, each in differen AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 11 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name        = "${var.app_name}-${var.env_name}-private"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

#Create 2 DB subnets for VPC, each in different AZ
resource "aws_subnet" "db" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 21 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
  tags = {
    Name        = "${var.app_name}-${var.env_name}-db"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

#Internet Gateway for the VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.app_name}-${var.env_name}-igw"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

# Route the public subnet trafic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Create a NAT gateway with an EIP for each private subnet to get internet connectivity
resource "aws_eip" "gw" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name        = "${var.app_name}-${var.env_name}-eip"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

resource "aws_nat_gateway" "gw" {
  subnet_id     = aws_subnet.public.0.id
  allocation_id = aws_eip.gw.id
  tags = {
    Name        = "${var.app_name}-${var.env_name}-nat-gateway"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

# Create a new route table for the public subnets, make it route non-local traffic through the Internet gateway to the internet
resource "aws_route_table" "public" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name        = "${var.app_name}-${var.env_name}-public"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

# Explicitly associate the newly created route tables to the public subnets (so they don't default to the main route table)
resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }
  tags = {
    Name        = "${var.app_name}-${var.env_name}-private"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# Create a new route table for the DB subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "db" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }
  route {
    cidr_block                = "10.10.0.0/16"
    vpc_peering_connection_id = "pcx-06c6a1495d0c0d1f7"
  }
  tags = {
    Name        = "${var.app_name}-${var.env_name}-db"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

# Explicitly associate the newly created route tables to the DB subnets (so they don't default to the main route table)
resource "aws_route_table_association" "db" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.db.*.id, count.index)
  route_table_id = element(aws_route_table.db.*.id, count.index)
}