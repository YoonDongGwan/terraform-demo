resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidr_blocks)
  vpc_id = var.vpc_id
  cidr_block = element(var.subnet_cidr_blocks,count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = var.automatic_public_ip
  tags = {
    Name = var.subnet_name
  }
}
resource "aws_internet_gateway" "internet_gateway" {
  count = 1
  vpc_id = var.vpc_id
}

resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = var.route_table_gateway_id
  }
  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }
}