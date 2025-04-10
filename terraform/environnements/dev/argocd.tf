data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "null_resource" "wait_for_cluster" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "helm_release" "argocd" {
  depends_on = [null_resource.wait_for_cluster]
  
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.46.7"
  create_namespace = true
  
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

resource "null_resource" "setup_argocd_repo" {
  depends_on = [helm_release.argocd]

  provisioner "local-exec" {
    command = <<EOF
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f - <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: repo-secret
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: ${var.git_repo_url}
YAML
EOF
  }
}

# Configuration de l'application
resource "null_resource" "setup_argocd_app" {
  depends_on = [null_resource.setup_argocd_repo]

  provisioner "local-exec" {
    command = <<EOF
kubectl apply -n argocd -f - <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: initial-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: ${var.git_repo_url}
    targetRevision: main
    path: ci-cd/argocd/applications/dev
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
YAML
EOF
  }
}