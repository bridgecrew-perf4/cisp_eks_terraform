data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}


resource "aws_subnet" "public" {
  count = 3
  vpc_id = data.aws_vpc.selected.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  

  tags = {
    format("kubernetes.io/cluster/%s",var.eks_cluster_name) = "shared"
    "kubernetes.io/cluster/elb" = "1"
    "kubernetes.io/role/elb" = "1"
    Name = format("pubsub-%s-%s",var.eks_cluster_name,count.index)
  }
}

resource "aws_subnet" "private" {
  count= 3
  vpc_id = data.aws_vpc.selected.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.private_subnets[count.index]
  

  tags = {
    format("kubernetes.io/cluster/%s",var.eks_cluster_name) = "shared"
    "kubernetes.io/cluster/internal-elb" = "1"
    "kubernetes.io/role/internal-elb" = "1"
    Name = format("privsub-%s-%s",var.eks_cluster_name,count.index)
  }
}



data "aws_internet_gateway" "default" {
  filter {
    name = "attachment.vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}
 
resource "aws_route" "main" {
  route_table_id         = data.aws_vpc.selected.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.default.id
}

