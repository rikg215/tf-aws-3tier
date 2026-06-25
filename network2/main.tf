resource "aws_vpc" "rainlabs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.tag_name
  }
}

resource "aws_subnet" "rainlab_public_subnets" {
  for_each                = var.public_subnets
  availability_zone       = each.value["az"]
  cidr_block              = each.value["cidr"]
  vpc_id                  = aws_vpc.rainlabs_vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.basename}-public_subnet-${each.key}"
  }
}

resource "aws_subnet" "rainlab_private_subnets" {
  for_each          = var.private_subnets
  availability_zone = each.value["az"]
  cidr_block        = each.value["cidr"]
  vpc_id            = aws_vpc.rainlabs_vpc.id

  tags = {
    Name = "${var.basename}-private_subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "rainlabs_igw" {
  vpc_id = aws_vpc.rainlabs_vpc.id

  tags = {
    Name = "${var.basename}-igw"
  }
}

resource "aws_eip" "rainlabs_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.basename}-nat-eip"
  }
}

resource "aws_nat_gateway" "rainlabs_ngw" {
  allocation_id = aws_eip.rainlabs_eip.id
  subnet_id     = aws_subnet.rainlab_public_subnets["sub-1"].id

  tags = {
    Name = "${var.basename}-ngw"
  }
  depends_on = [aws_internet_gateway.rainlabs_igw]
}

resource "aws_route_table" "rainlabs_pubrt" {
  vpc_id = aws_vpc.rainlabs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rainlabs_igw.id
  }

  tags = {
    Name = "${var.basename}-public-rt"
  }
}

resource "aws_route_table" "rainlabs_privrt" {
  vpc_id = aws_vpc.rainlabs_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.rainlabs_ngw.id
  }

  tags = {
    Name = "${var.basename}-private-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.rainlab_public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rainlabs_pubrt.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.rainlab_private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rainlabs_privrt.id
}

# security group that handles ssh
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "security group regarding ssh rules"
  vpc_id      = aws_vpc.rainlabs_vpc.id

  tags = {
    Name = "sg-ssh"
  }
}

# ingress rule allowing ssh traffic (port 22) in from my public ip
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4         = "174.55.206.199/32"
  from_port         = "22"
  to_port           = "22"
  ip_protocol = "tcp"
}

# security group that handles web access
resource "aws_security_group" "web" {
  name        = "web"
  description = "security group for web access control"
  vpc_id      = aws_vpc.rainlabs_vpc.id

  tags = {
    Name = "sg-web"
  }
}

# rule created to allow http access from anywhere
resource "aws_vpc_security_group_ingress_rule" "allow_web" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "80"
  to_port           = "80"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"   # -1 = all protocols/ports
}