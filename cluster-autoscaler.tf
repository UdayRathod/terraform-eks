
resource "aws_iam_role" "cluster-autoscaler-role" {
  name        = "cluster-autoscaler-role"
  description = "IAM role for EKS Cluster Autoscaler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "cluster-autoscaler-policy" {
  name        = "cluster-autoscaler-policy"
  description = "Policy for EKS Cluster Autoscaler"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup"
          ]
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeScalingActivities",
            "autoscaling:DescribeTags",
            "ec2:DescribeImages",
            "ec2:DescribeInstanceTypes",
            "ec2:DescribeLaunchTemplateVersions",
            "ec2:GetInstanceTypesFromInstanceRequirements",
            "eks:DescribeNodegroup"
          ]
          "Resource" : "*"
        }
      ]
  })
}


resource "aws_iam_role_policy_attachment" "cluster-autoscaler-attachment" {
  role       = aws_iam_role.cluster-autoscaler-role.name
  policy_arn = aws_iam_policy.cluster-autoscaler-policy.arn
}


resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
  }
}

resource "aws_eks_pod_identity_association" "cluster-autoscaler-association" {
  cluster_name    = module.eks.cluster_name
  role_arn        = aws_iam_role.cluster-autoscaler-role.arn
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  depends_on      = [aws_iam_role_policy_attachment.cluster-autoscaler-attachment]
}

resource "helm_release" "cluster-autoscaler" {
  name = "cluster-autoscaler"

  repository = "https://kubernetes.github.io/autoscaler"
  namespace  = "kube-system"
  version    = "9.37.0"
  chart      = "cluster-autoscaler"

  set = [
    {
      name  = "rbac.serviceAccount.name"
      value = "cluster-autoscaler"
    },
    {
      name  = "awsRegion"
      value = var.aws_region
    },
    {
      name  = "autoDiscovery.clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    }
  ]

  depends_on = [helm_release.metrics-server, module.eks]

}