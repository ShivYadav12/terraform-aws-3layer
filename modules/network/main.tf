
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = "${var.project_name}-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, { Name = "${var.project_name}-igw" })
}

resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => cidr }
  vpc_id = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = data.aws_availability_zones.available.names[each.key]
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "${var.project_name}-public-${each.key}" })
}

resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => cidr }
  vpc_id = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = data.aws_availability_zones.available.names[each.key]
  map_public_ip_on_launch = false
  tags = merge(var.tags, { Name = "${var.project_name}-private-${each.key}" })
}

resource "aws_eip" "nat" {
  count = length(var.public_subnets) > 0 ? 1 : 0
  vpc = true
  tags = merge(var.tags, { Name = "${var.project_name}-nat-eip" })
}

resource "aws_nat_gateway" "natgw" {
  count = length(aws_subnet.public) > 0 ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id = element(values(aws_subnet.public).*id, 0)
  tags = merge(var.tags, { Name = "${var.project_name}-nat" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, { Name = "${var.project_name}-public-rt" })
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public
  subnet_id = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, { Name = "${var.project_name}-private-rt" })
}

resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = length(aws_nat_gateway.natgw) > 0 ? aws_nat_gateway.natgw[0].id : null
  depends_on = [aws_nat_gateway.natgw]
}

resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private
  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = values(aws_subnet.public).*id
}

output "private_subnets" {
  value = values(aws_subnet.private).*id
}
