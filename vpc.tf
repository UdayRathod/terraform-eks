
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = var.vpc-name
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available
  public_subnets  = [for subnet in range(var.vpc_public_subnet_count) : cidrsubnet(var.public-subnets-cidr, 8, subnet)]
  private_subnets = [for subnet in range(var.vpc_private_subnet_count) : cidrsubnet(var.private-subnets-cidr, 8, subnet)]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = local.common_tags


  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks-cluster-name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
    Managed_by                                        = "Terraform"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks-cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
    Managed_by                                        = "Terraform"
  }
}


