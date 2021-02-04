
resource "aws_security_group" "allow_mariadb" {

  name        = "mariadb_sg"
  description = "MariaDB Security Group"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "MariaDB Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # cidr_blocks é a origem da conexão
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow output to all addresses"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "allow_output_from_private" {
  name        = "Allow Egress from EKS node"
  description = "Allow EKS nodes to reach the internet"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
