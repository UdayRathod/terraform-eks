
provider "aws" {
  region = var.aws_region
}
# EKS Cluster Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"


  cluster_name             = local.eks-cluster-name
  cluster_version          = var.eks-cluster-version
  enable_irsa              = true
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # If you want to give other users/roles access to your EKS cluster, you can provide the arns in access entry otherwise no one will be able to access your cluster.
  access_entries = {
    # One access entry with a policy associated
    example = {
      principal_arn = "arn:aws:iam::<Account-ID>:root"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "Cluster"
          }
        }
      }
    }
  }


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.micro", "m5.large", "m5.xlarge"]
  }

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type               = "AL2023_x86_64_STANDARD"
      instance_types         = ["m5.xlarge"]
      node_security_group_id = ["aws_security_group.eks-node-sg.id"]

      min_size     = 4
      max_size     = 8
      desired_size = 4
    }
  }

  tags = local.common_tags
}

