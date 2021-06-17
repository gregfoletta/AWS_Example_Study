provider "aws" {
  region     = "ap-southeast-2"
}


# Two separate VPCs, prod and dev and shared
### Dev VPC ### 
resource "aws_vpc" "dev" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TGW Study - Dev"
  }
}

resource "aws_route_table" "dev" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "TGW Study - Dev"
  }
}

resource "aws_main_route_table_association" "dev" {
  vpc_id         = aws_vpc.dev.id
  route_table_id = aws_route_table.dev.id
}

resource "aws_subnet" "dev_a" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "TGW Study - Dev - Subnet A"
  }
}

resource "aws_subnet" "dev_b" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "TGW Study - Dev - Subnet B"
  }
}


### Prod VPC ### 
resource "aws_vpc" "prod" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TGW Study - Prod"
  }
}

resource "aws_route_table" "prod" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "TGW Study - Prod"
  }
}

resource "aws_main_route_table_association" "prod" {
  vpc_id         = aws_vpc.prod.id
  route_table_id = aws_route_table.prod.id
}

resource "aws_subnet" "prod_a" {
  vpc_id = aws_vpc.prod.id
  cidr_block = "10.1.0.0/24"

  tags = {
    Name = "TGW Study - Prod - Subnet A"
  }
}

resource "aws_subnet" "prod_b" {
  vpc_id = aws_vpc.prod.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "TGW Study - Prod- Subnet B"
  }
}

### Shared  VPC ### 
resource "aws_vpc" "shared" {
  cidr_block       = "10.2.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TGW Study - Shared"
  }
}

resource "aws_route_table" "shared_front" {
  vpc_id = aws_vpc.shared.id

  tags = {
    Name = "TGW Study - Shared - Front"
  }
}

resource "aws_route_table" "shared_back" {
  vpc_id = aws_vpc.shared.id

  tags = {
    Name = "TGW Study - Shared - Back"
  }
}


resource "aws_subnet" "shared_front" {
  vpc_id = aws_vpc.shared.id
  cidr_block = "10.2.0.0/24"

  tags = {
    Name = "TGW Study - Shared - Front"
  }
}

resource "aws_subnet" "shared_back" {
  vpc_id = aws_vpc.shared.id
  cidr_block = "10.2.1.0/24"

  tags = {
    Name = "TGW Study - Shared - Back"
  }
}

resource "aws_route_table_association" "shared_front" {
  subnet_id         = aws_subnet.shared_front.id
  route_table_id = aws_route_table.shared_front.id
}


resource "aws_route_table_association" "shared_back" {
  subnet_id         = aws_subnet.shared_back.id
  route_table_id = aws_route_table.shared_back.id
}

resource "aws_internet_gateway" "shared_back" {
  vpc_id = aws_vpc.shared.id

  tags = {
    Name = "TGW - Shared - IGW"
  }
}

resource "aws_route" "shared_back_igw" {
  route_table_id = aws_route_table.shared_back.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.shared_back.id
}


### Transit Gateway Configuraiton ###
resource "aws_ec2_transit_gateway" "study" {
  description = "TGW Study"
 
  # All the values below are the defaults
  # Amazon ASN for BGP
  amazon_side_asn = "64512"

  # Are attachment requests automatically accepted?
  auto_accept_shared_attachments = "disable"

  # Are resource attachments automatically associated with the default association route table?
  default_route_table_association = "enable"

  # Whether resource attachments automatically propagate routes the default propagation route table
  default_route_table_propagation = "enable"

  # DNS Support
  dns_support = "enable"

  # ECMP support across VPNs
  vpn_ecmp_support = "enable"

  tags = {
    Name = "TGW Study"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dev" {
  subnet_ids = [aws_subnet.dev_a.id]
  transit_gateway_id = aws_ec2_transit_gateway.study.id
  vpc_id = aws_vpc.dev.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "prod" {
  subnet_ids = [aws_subnet.prod_a.id]
  transit_gateway_id = aws_ec2_transit_gateway.study.id
  vpc_id = aws_vpc.prod.id
}
