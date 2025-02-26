provider "aws" {
  region = "us-east-1"
}

# availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

module "globalvars" {
  source = "../globalvars"
}

locals {
  default_tags = merge(
    module.globalvars.default_tags,
    { "Env" = var.env }
  )
  prefix      = module.globalvars.prefix
  name_prefix = "${local.prefix}-${var.env}"
}

# new VPC 
resource "aws_vpc" "vpc_main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-vpc"
    }
  )
  
  enable_dns_hostnames = true
  enable_dns_support = true
}

# public subnet in the default VPC
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.public_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-public-subnet-${count.index}"
    }
  )
}


resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-private-subnet-${count.index}"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.vpc_main.id

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-igw"
    }
  )
}

#nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[1].id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-nat_gw"
    }
  )

}


# Route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-public-route-table"
    }
  )
}

# the custom route table
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet[*].id)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-private-route-table"
    }
  )
}

# the custom route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet[*].id)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-nat-eip"
    }
  )
}
