resource "aws_vpc" "rainlabs" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "rainlabs"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.rainlabs.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-1a"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id            = aws_vpc.rainlabs.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-1b"
  }
}


resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.rainlabs.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-1a"
  }
}


resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.rainlabs.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-1b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.rainlabs.id


  tags = {
    Name = "rainlabs-gw"
  }
}


resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-1a.id


  tags = {
    Name = "rainlabs-natgw"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_route_table" "rt-pub" {
  vpc_id = aws_vpc.rainlabs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "rt-priv" {
  vpc_id = aws_vpc.rainlabs.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.rt-pub.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.rt-pub.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.rt-priv.id
}

resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.rt-priv.id
}
