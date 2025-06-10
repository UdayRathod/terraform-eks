data "aws_eks_cluster" "name" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# This file configures the Helm provider to deploy the metrics-server on an EKS cluster.
# It uses the EKS module to get the cluster endpoint and certificate authority data for authentication.

# Configures the Helm provider to interact with the Kubernetes cluster using EKS credentials.
provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--cache"]
    }
  }
}

# This resource deploys the metrics-server Helm chart in the kube-system namespace of the EKS cluster.
resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.12.1"

  set = [
    {
      name  = "defaultArgs[0]"
      value = "--cert-dir=/tmp"
    },
    {
      name  = "defaultArgs[1]"
      value = "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"
    },
    {
      name  = "defaultArgs[2]"
      value = "--kubelet-use-node-status-port"
    },
    {
      name  = "defaultArgs[3]"
      value = "--metric-resolution=15s"
    }
  ]

  depends_on = [module.eks]
}