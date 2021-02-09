##
## Allow AWS EKS to call other services in your behalf.
##

resource "aws_iam_role" "main" {
 name = "trust_eks_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.main.name
}

##
## Allow AWS EC2 to call other resources/services in your behalf
##
resource "aws_iam_role" "main2" {
  name = "poc_eks_node_group_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.main2.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.main2.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.main2.name
}



##
## AWS EKS Auto Scaler role and policy
##
resource "aws_iam_role" "AmazonEKSClusterAutoscalerRole" {
  name = "AmazonEKSClusterAutoscalerRole"
  
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::707413322123:oidc-provider/oidc.eks.sa-east-1.amazonaws.com/id/1BEF3D72EE241C0D012E53A2DFAD560E"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.sa-east-1.amazonaws.com/id/1BEF3D72EE241C0D012E53A2DFAD560E:sub" : "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "AmazonEKSClusterAutoscalerPolicy" {
  name = "AmazonEKSClusterAutoscalerPolicy"
  description = "Allows AutoScaling for EKS Node Group"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "autoscaling:DescribeAutoScalingGroups",
              "autoscaling:DescribeAutoScalingInstances",
              "autoscaling:DescribeLaunchConfigurations",
              "autoscaling:DescribeTags",
              "autoscaling:SetDesiredCapacity",
              "autoscaling:TerminateInstanceInAutoScalingGroup",
              "ec2:DescribeLaunchTemplateVersions"
          ],
          "Resource": "*",
          "Effect": "Allow"
      }
  ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterAutoscalerPolicy" {
  policy_arn = aws_iam_policy.AmazonEKSClusterAutoscalerPolicy.arn
  role = aws_iam_role.AmazonEKSClusterAutoscalerRole.name
}
