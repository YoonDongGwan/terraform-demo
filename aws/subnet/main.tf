resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidr_blocks)
  vpc_id = var.vpc_id
  cidr_block = element(var.subnet_cidr_blocks,count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = var.automatic_public_ip
  tags = {
    Name = "subnet-${element(var.availability_zones, count.index)}-${var.access_modifier}"
  }
}
resource "aws_internet_gateway" "internet_gateway" {
  count = var.access_modifier == "public" ? 1 : 0
  vpc_id = var.vpc_id
  tags = {
    Name = "igw-${var.region}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = var.access_modifier == "private" ? 1 : 0
  allocation_id = aws_eip.nat_ip[0].id
  subnet_id = var.nat_subnet_id
  tags = {
    Name = "nat-${var.nat_az}-public"
  }
}

resource "aws_eip" "nat_ip" {
  count = var.access_modifier == "private" ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "eip-${var.nat_az}-nat"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.access_modifier == "public" ? aws_internet_gateway.internet_gateway[0].id : null
    nat_gateway_id = var.access_modifier == "private" ? aws_nat_gateway.nat_gateway[0].id : null
  }
  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }
  tags = {
    Name = "rtb-${var.region}-${var.access_modifier}"
  }
}

resource "aws_route_table_association" "route_table_association" {
  count = length(var.subnet_cidr_blocks)
  subnet_id = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.route_table.id
}