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
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]

  #lifecycle {
  #  ignore_changes = [scaling_config.0.desired_size]
  #}

}

