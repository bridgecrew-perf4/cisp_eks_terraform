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
resource "aws_iam_role" "eks_node_group_role" {
  name = "eks_node_group_role"

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
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
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
          "Federated" : format("arn:aws:iam::707413322123:oidc-provider/%s", replace(aws_eks_cluster.main.identity[0].oidc[0].issuer,"https://",""))
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            format("%s:sub",replace(aws_eks_cluster.main.identity[0].oidc[0].issuer,"https://","")) : "system:serviceaccount:kube-system:cluster-autoscaler"
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


##
## EKS access to RDS service
##
resource "aws_iam_policy" "AmazonEKStoRDSAccess" {
  name = "AmazonEKStoRDSAccess"
  description = "Policy for EKS service reach RDS service"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
             "rds-db:connect"
         ],
         "Resource": "*"
      }
   ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKStoRDSAccess" {
  policy_arn = aws_iam_policy.AmazonEKStoRDSAccess.arn
  role = aws_iam_role.eks_node_group_role.name
}




##
## EKS Role for Route53
##
#resource "aws_iam_role" "AllowExternalDNSUpdates" {
#  name = "AllowExternalDNSUpdates"
#
#  #assume_role_policy = jsonencode({
#  #  "Version" : "2012-10-17",
#  #  "Statement" : [
#  #    {
#  #      "Effect" : "Allow",
#  #      "Principal" : {
#  #        "Federated" : format("arn:aws:iam::707413322123:oidc-provider/%s", replace(aws_eks_cluster.main.identity[0].oidc[0].issuer,"https://",""))
#  #      },
#  #      "Action" : "sts:AssumeRoleWithWebIdentity",
#  #      "Condition" : {
#  #        "StringEquals" : {
#  #          format("%s:sub",replace(aws_eks_cluster.main.identity[0].oidc[0].issuer,"https://","")) : "system:serviceaccount:kube-system:external-dns"
#  #        }
#  #      }
#  #    }
#  #  ]
#  #})
#  assume_role_policy = jsonencode({
#    Statement = [{
#      Action = "sts:AssumeRole"
#      Effect = "Allow"
#      Principal = {
#        Service = "ec2.amazonaws.com"
#      }
#    },
#    {
#      Action = "sts:AssumeRole"
#      Effect = "Allow"
#      Principal = {
#        Identifiers = format("%s",aws_iam_role.eks_node_group_role.arn)
#      }
#    }]
#    Version = "2012-10-17"
#  })
#
#}
#
#
###
### EKS Policy for Route53
###
#resource "aws_iam_policy" "AllowExternalDNSUpdates" {
#  name = "AllowExternalDNSUpdates"
#  description = "Policy that allows EKS to update Route53 records"
#
#  policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Action": [
#        "route53:ChangeResourceRecordSets"
#      ],
#      "Resource": [
#        "arn:aws:route53:::hostedzone/*"
#      ]
#    },
#    {
#      "Effect": "Allow",
#      "Action": [
#        "route53:ListHostedZones",
#        "route53:ListResourceRecordSets"
#      ],
#      "Resource": [
#        "*"
#      ]
#    }
#  ]
#}
#  EOF
#}
#
#resource "aws_iam_role_policy_attachment" "AllowExternalDNSUpdates" {
#  policy_arn = aws_iam_policy.AllowExternalDNSUpdates.arn
#  role = aws_iam_role.AllowExternalDNSUpdates.name
#}
