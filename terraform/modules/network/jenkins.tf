resource "aws_subnet" "private_subnet_jenkins" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.aws_region
  map_public_ip_on_launch = false
  
  tags = {
    Name = "jenkins-private-subnet"
  }
}

resource "aws_subnet" "public_subnet_bastion" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr 
  availability_zone       = var.aws_region
  map_public_ip_on_launch = true  
  
  tags = {
    Name = "bastion-public-subnet"
  }
}

resource "aws_eip" "bastion_eip" {
  domain = "vpc"
  tags = {
    Name = "jenkins-bastion-eip"
  }
}

resource "aws_eip_association" "bastion_eip_assoc" {
  instance_id   = var.bastion_instance_id
  allocation_id = aws_eip.bastion_eip.id
}

resource "aws_route_table_association" "bastion_route_table_assoc" {
  subnet_id      = aws_subnet.public_subnet_bastion.id
  route_table_id = aws_route_table.public.id
}