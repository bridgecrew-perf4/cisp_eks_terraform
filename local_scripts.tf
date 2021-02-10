resource "null_resource" "k8s_config" {

  triggers = {
    always_run = aws_eks_cluster.main.id
  }

  provisioner "local-exec" {
    command = format("./scripts/k8s_config.sh %s %s %s",var.region,var.eks_cluster_name,aws_iam_role.AmazonEKSClusterAutoscalerRole.arn)
  }

}
