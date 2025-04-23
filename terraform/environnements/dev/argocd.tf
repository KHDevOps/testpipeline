module "argocd" {
  source = "../../modules/argocd"
  
  namespace         = "argocd"
  
  local_chart_path  = "${path.module}/../../../helm-charts/argo-cd"
  
  values_file       = "${path.module}/../../../helm-values/dev/argocd/values.yaml"
  
  helm_sets = [
    {
      name  = "server.extraArgs[0]"
      value = "--insecure"
    },
    {
      name  = "server.service.type"
      value = "ClusterIP"
    }
  ]
  
  depends_on = [
    module.eks
  ]
}