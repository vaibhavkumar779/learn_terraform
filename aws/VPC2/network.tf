resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.NewVPC.id

  tags = {
    Name = "Internet_GW"
  }
}


resource "aws_route_table" "Route_public" {
  vpc_id = aws_vpc.NewVPC.id
  depends_on = [
    aws_internet_gateway.igw
  ]
 route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Route Public"
  }
}

resource "aws_route_table_association" "rta_public" {
  depends_on = [
    aws_route_table.Route_public
  ]
  subnet_id      = aws_subnet.public.id 
  route_table_id = aws_route_table.Route_public.id
}

 resource "aws_eip" "NAT_IP" {
    depends_on = [
      aws_internet_gateway.igw
    ]
    vpc = true
 }

 resource "aws_nat_gateway" "NAT_GW" {
   
   depends_on = [
     aws_eip.NAT_IP
   ]
   allocation_id = aws_eip.NAT_IP.id
   subnet_id = aws_subnet.private.id
   
 }

resource "aws_route_table" "Route_private" {
    vpc_id = aws_vpc.NewVPC.id

    depends_on = [
      aws_nat_gateway.NAT_GW
    ]
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.NAT_GW.id
    }

    tags = {
       Name = "Route Private"
    }
}

resource "aws_route_table_association" "rta_private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.Route_private.id
}