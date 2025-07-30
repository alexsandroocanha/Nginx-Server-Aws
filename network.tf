# VPC

resource "aws_vpc" "minha_rede" {
  cidr_block = "192.168.0.0/24"
}

resource "aws_subnet" "rede_1" {
  vpc_id            = aws_vpc.minha_rede.id
  cidr_block        = "192.168.0.0/26"
  availability_zone = var.availability_zone
}

resource "aws_subnet" "rede_2" {
  vpc_id            = aws_vpc.minha_rede.id
  cidr_block        = "192.168.0.64/26"
  availability_zone = var.availability_zone
}

resource "aws_subnet" "rede_3" {
  vpc_id            = aws_vpc.minha_rede.id
  cidr_block        = "192.168.0.128/26"
  availability_zone = var.availability_zone
}

resource "aws_subnet" "rede_4" {
  vpc_id            = aws_vpc.minha_rede.id
  cidr_block        = "192.168.0.192/26"
  availability_zone = var.availability_zone
}




# Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.minha_rede.id
}




# Rotas de IP

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.minha_rede.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.rede_1.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table" "public_rt2" {
  vpc_id = aws_vpc.minha_rede.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.rede_3.id
  route_table_id = aws_route_table.public_rt2.id
}




# Security Group

resource "aws_security_group" "seguranca_compac" {
  name        = "seguranca_compac"
  description = "Grupo de seguranca para as instancias EC2"
  vpc_id      = aws_vpc.minha_rede.id
}

resource "aws_vpc_security_group_ingress_rule" "seguranca_compac_ipv4" {
  security_group_id = aws_security_group.seguranca_compac.id
  cidr_ipv4         = aws_vpc.minha_rede.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "seguranca_compac_ssh" {
  security_group_id = aws_security_group.seguranca_compac.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "seguranca_compac_https" {
  security_group_id = aws_security_group.seguranca_compac.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "seguranca_compac_traffic_ipv4" {
  security_group_id = aws_security_group.seguranca_compac.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}




# Interfaces

resource "aws_network_interface" "interface1" {
  subnet_id       = aws_subnet.rede_1.id
  security_groups = [aws_security_group.seguranca_compac.id]
}

resource "aws_network_interface" "interface2" {
  subnet_id       = aws_subnet.rede_2.id
  security_groups = [aws_security_group.seguranca_compac.id]
}

resource "aws_network_interface" "interface3" {
  subnet_id       = aws_subnet.rede_3.id
  security_groups = [aws_security_group.seguranca_compac.id]
}

resource "aws_network_interface" "interface4" {
  subnet_id       = aws_subnet.rede_4.id
  security_groups = [aws_security_group.seguranca_compac.id]
}




# Elastic IP

resource "aws_eip" "eip1" {
  domain = "vpc"
}

resource "aws_eip_association" "assoc1" {
  allocation_id        = aws_eip.eip1.id
  network_interface_id = aws_network_interface.interface1.id
}

resource "aws_eip" "eip2" {
  domain = "vpc"
}

resource "aws_eip_association" "assoc2" {
  allocation_id        = aws_eip.eip2.id
  network_interface_id = aws_network_interface.interface3.id
}