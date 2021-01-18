#resource "aws_db_parameter_group" "default" {
#  name = "mariadb"
#  family = "mariadb10.5"
#}

resource "aws_db_subnet_group" "default" {
  name = "main"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "default" {
  identifier = var.rds_identifier
  allocated_storage = var.rds_storage
  storage_type = var.rds_type
  engine = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class
  name = var.rds_name
  username = var.rds_username
  password = var.rds_pass
#  parameter_group_name = aws_db_parameter_group.default.name
  db_subnet_group_name = aws_db_subnet_group.default.name
  multi_az = true
  skip_final_snapshot = true
}

