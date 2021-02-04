##
## AWS RDS db Parameters
##
#resource "aws_db_parameter_group" "default" {
#  name = "mariadb"
#  family = "mariadb10.5"
#}

##
## AWS RDS Subnet definition
##
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.private[*].id
}

##
## AWS RDS DB Instance
##
resource "aws_db_instance" "default" {
  identifier     = var.rds_identifier
  storage_type   = var.rds_type
  engine         = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class
  name           = var.rds_name
  username       = var.rds_username
  password       = var.rds_pass
  #  parameter_group_name = aws_db_parameter_group.default.name
  db_subnet_group_name = aws_db_subnet_group.default.name

  ## Configuração de MultiAZ
  multi_az = true

  ## Security Groups e acesso público (não funciona tendo a rede como privada)
  vpc_security_group_ids = list(aws_security_group.allow_mariadb.id)
  publicly_accessible    = false

  ## AWS RDS Autoscaling
  allocated_storage     = var.rds_storage
  max_allocated_storage = var.rds_max_storage

  ## Configurações de Backup
  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.rds_backup_window

  ## Não realizar o snapshot ao deletar a instância
  skip_final_snapshot = true

}

