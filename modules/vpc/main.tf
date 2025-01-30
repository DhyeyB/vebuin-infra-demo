data "aws_availability_zones" "available" {
}

resource "aws_vpc" "app-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.app_name}-${var.environment}-vpc"
    Environment = "${var.environment}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name        = "${var.app_name}-${var.environment}-igw"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.app-vpc.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.app-vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-${var.environment}-public-sub"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name        = "${var.app_name}-${var.environment}-rt-public"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "public" {
  count                  = var.az_count #Length of public subnet
  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = var.public_route_destination_cidr_block
  gateway_id             = element(aws_internet_gateway.igw.*.id, count.index)
}

resource "aws_route_table_association" "public" {
  count          = var.az_count //length of public subnets
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}
