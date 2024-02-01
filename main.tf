terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::577645017848:role/roleForTerraform"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc1"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "subnet2"
  }
}

resource "aws_internet_gateway" "internet_gateway1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet_gateway1"
  }
}

resource "aws_route_table" "route_table1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "10.0.0.0/8"
    gateway_id = aws_internet_gateway.internet_gateway1.id
  }
}

resource "aws_route_table_association" "route_table_association1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table1.id
}

resource "aws_route_table_association" "route_table_association2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route_table1.id
}
