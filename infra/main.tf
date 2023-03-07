# Create a VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    "Name" = "Dev"
  }
}

# resource "aws_subnet" "private" {
#   vpc_id     = aws_vpc.dev_vpc.id
#   cidr_block = "10.0.0.0/27"

#   tags = {
#     Name = "Private"
#   }
# }

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.0.32/27"

  tags = {
    Name = "Public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route_table.id
}
