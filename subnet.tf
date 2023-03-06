resource "aws_subnet" "subnet_creation" {
  for_each = var.subnets
  vpc_id = data.aws_vpc.vpc.id

  availability_zone = each.value.availability_zone
  cidr_block = each.value.cidr_block

}


resource "aws_internet_gateway" "gateway" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "lydiaGW"
  }
}


resource "aws_route_table" "public-route" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "public-route"
  }
}

resource "aws_route_table_association" "route_association" {

  subnet_id =  aws_subnet.subnet_creation["publicsubnet"].id
  route_table_id = aws_route_table.public-route.id
}