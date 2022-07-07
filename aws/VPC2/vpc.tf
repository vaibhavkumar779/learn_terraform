resource "aws_vpc" "NewVPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  depends_on = [
    aws_vpc.NewVPC
  ]
  vpc_id                  = aws_vpc.NewVPC.id
  cidr_block              = var.public_subnets
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_subnet" "private" {
  depends_on = [
    aws_vpc.NewVPC,
  ]
  vpc_id            = aws_vpc.NewVPC.id
  cidr_block        = var.private_subnets
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.name}-private"
  }
}
