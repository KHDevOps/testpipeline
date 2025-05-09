terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5"
    }
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = var.namespace_labels
  }
}

resource "helm_release" "argocd" {
  name       = var.helm_release_name
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  

  chart      = var.local_chart_path
  
  values = [
    var.values_file != "" ? file(var.values_file) : "",
    var.additional_values
  ]
  
  dynamic "set" {
    for_each = var.helm_sets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
  
  timeout    = var.timeout
  atomic     = var.atomic
  wait       = var.wait
  
  depends_on = [
    kubernetes_namespace.argocd
  ]
}

resource "null_resource" "helm_cleanup" {
  depends_on = [helm_release.argocd]
  
  triggers = {
    namespace = var.namespace
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete namespace ${self.triggers.namespace} --ignore-not-found=true || true"
    on_failure = continue
  }
}