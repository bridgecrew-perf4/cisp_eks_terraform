
output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "rds_mariadb_endpoint" {
  value = aws_db_instance.apps.endpoint
}
output "rds_postgresql_endpoint" {
  value = aws_db_instance.api.endpoint
}
