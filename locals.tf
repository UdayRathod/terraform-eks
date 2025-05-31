locals {
  common_tags = {
    "kubernetes.io/cluster/${local.eks-cluster-name}" = "shared"
    Environment                                       = "Prod"
    Managed_by                                        = "Terraform"
  }

  eks-cluster-name = "aws-eks-${random_string.suffix.result}"
}


resource "random_string" "suffix" {
  length  = 4
  special = false
}
