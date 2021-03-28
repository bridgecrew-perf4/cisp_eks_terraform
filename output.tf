
output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

#output "kubeconfig-certificate-authority-data" {
#  value = aws_eks_cluster.main.certificate_authority[0].data
#}

output "rds_mariadb_endpoint" {
  value = aws_db_instance.apps.endpoint
}

output "rsd_postgresql_endpoint" {
  value = aws_db_instance.api.endpoint
}

data "aws_caller_identity" "current" {}
output "account_id"{
  value = data.aws_caller_identity.current.account_id
}


output "autoscaler_role" {
 value = aws_iam_role.AmazonEKSClusterAutoscalerRole.arn
}

output "eks_lb_arn" {
  value = aws_iam_role.eks_lb.arn
}


#output "external-dns-arn" {
#  value = aws_iam_role.AllowExternalDNSUpdates.arn
#}
