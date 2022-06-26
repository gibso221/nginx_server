locals {
  az_names = data.aws_availability_zones.available_zones.names

  # assume we have 1 az for each subnet specified by user
  az_map = {
    for zone in local.az_names : zone => var.subnet_ranges[index(local.az_names, zone)]
    if length(local.az_names) == length(var.subnet_ranges)
  }
}

data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment_name} VPC"
  }
}

### Gateways

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment_name} Internet Gateway"
    Environment = var.environment_name
  }
}

####

### Subnets

resource "aws_subnet" "public_subnet" {
  for_each = local.az_map

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.environment_name} Public Subnet ${each.key}"
  }
}

####

### Route tables

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = "${var.environment_name} Route Table"
  }
}

resource "aws_route_table_association" "public_associations" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

####