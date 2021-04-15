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
## AWS RDS MariaDB Instance - For applications
##
resource "aws_db_instance" "apps" {
  identifier     = var.rds_apps_identifier
  storage_type   = var.rds_type
  engine         = var.rds_apps_engine
  engine_version = var.rds_apps_engine_version
  instance_class = var.rds_instance_class
  name           = var.rds_apps_name
  username       = local.creds.rds_apps_username
  password       = local.creds.rds_apps_password
  #  parameter_group_name = aws_db_parameter_group.default.name
  db_subnet_group_name = aws_db_subnet_group.default.name

  ## Configuração de MultiAZ
  multi_az = true

  ## Security Groups e acesso público (não funciona tendo a rede como privada)
  vpc_security_group_ids = tolist([aws_security_group.allow_mariadb.id])
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

##
## AWS RDS Postgres Instance - For Konga and Kong API
##
resource "aws_db_instance" "api" {
  identifier     = var.rds_api_identifier
  storage_type   = var.rds_type
  engine         = var.rds_api_engine
  engine_version = var.rds_api_engine_version
  instance_class = var.rds_instance_class
  name           = var.rds_api_name
  username       = local.creds.rds_api_username
  password       = local.creds.rds_api_password
  #  parameter_group_name = aws_db_parameter_group.default.name
  db_subnet_group_name = aws_db_subnet_group.default.name

  ## Configuração de MultiAZ
  multi_az = false

  ## Security Groups e acesso público (não funciona tendo a rede como privada)
  vpc_security_group_ids = tolist([aws_security_group.allow_postgresql.id])
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

