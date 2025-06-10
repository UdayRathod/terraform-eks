
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available
  public_subnets  = [for subnet in range(var.vpc_public_subnet_count) : cidrsubnet(var.public_subnets_cidr, 8, subnet)]
  private_subnets = [for subnet in range(var.vpc_private_subnet_count) : cidrsubnet(var.private_subnets_cidr, 8, subnet)]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = local.common_tags


  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
    Managed_by                                        = "Terraform"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
    Managed_by                                        = "Terraform"
  }
}


