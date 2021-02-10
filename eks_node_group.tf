##
## AWS EKS Node Group
##
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.main2.arn
  subnet_ids      = aws_subnet.private[*].id


  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = var.eks_instance_types
  disk_size      = var.eks_instance_disk_size

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  #lifecycle {
  #  ignore_changes = [scaling_config.0.desired_size]
  #}

  tags = {
    format("k8s.io/cluster-autoscaler/%s",var.eks_cluster_name) = "owned"
    "k8s.io/cluster-autoscaler/enabled" = true
  }

}

