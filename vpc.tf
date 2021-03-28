##
## AWS VPC: Utilizando a mesma VPC já existente e zonas
##
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}


##
## Subnet Pública para LoadBalancers
##
resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = data.aws_vpc.selected.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  

  tags = {
    format("kubernetes.io/cluster/%s", var.eks_cluster_name) = "shared"
    "kubernetes.io/cluster/elb"                              = "1"
    "kubernetes.io/role/elb"                                 = "1"
    Name                                                     = format("pubsub-%s-%s", var.eks_cluster_name, count.index)
  }
}

##
## Subnet privada para nodes do EKS e RDS
## 
resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = var.private_subnets[count.index]

  tags = {
    format("kubernetes.io/cluster/%s", var.eks_cluster_name) = "shared"
    "kubernetes.io/cluster/internal-elb"                     = "1"
    "kubernetes.io/role/internal-elb"                        = "1"
    Name                                                     = format("privsub-%s-%s", var.eks_cluster_name, count.index)
  }
}


##
## Definição de Rota e Internet Gateway para VPC
##
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

resource "aws_route" "public" {
  route_table_id         = data.aws_vpc.selected.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.default.id
}


##
## NAT Gateway paras maquinas na rede privada terem acesso a internet.
##
resource "aws_eip" "eip_nat_gw" {
  count = 3
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  count         = 3
  allocation_id = aws_eip.eip_nat_gw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = format("NATGw-%s", count.index)
  }

}

resource "aws_route_table" "private" {
  count  = 3
  vpc_id = data.aws_vpc.selected.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = format("Route table for NAT gatewa %s", count.index)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private_to_nat" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

