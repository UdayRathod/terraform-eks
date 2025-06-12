resource "helm_release" "argo-cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  version    = "8.0.17"

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
  
  set {
    name  = "server.ingress.path"
    value = "/argocd"
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "alb"
  }

  set {
    name  = "server.ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "alb"
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internet-facing"
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
    value = "ip"
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports"
    value = "[{\"HTTP\": 80}]"
  }

  set {
  name  = "server.service.type"
  value = "ClusterIP"
 }

 set {
  name  = "configs.secret.argocdServerAdminPassword"
  value = var.argocd_admin_password
 }

  depends_on = [module.eks]
  
  
}