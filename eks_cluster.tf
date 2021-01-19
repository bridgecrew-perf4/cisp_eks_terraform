resource "aws_eks_cluster" "main" {
  name = var.eks_cluster_name
  role_arn = aws_iam_role.main.arn
  version = var.eks_k8s_version 

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]

  lifecycle {
    create_before_destroy = true
  }

}


