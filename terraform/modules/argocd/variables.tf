variable "namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "namespace_labels" {
  description = "Labels to apply to the Argo CD namespace"
  type        = map(string)
  default     = {}
}

variable "helm_release_name" {
  description = "Name of the Helm release"
  type        = string
  default     = "argocd"
}

variable "chart_repository_url" {
  description = "URL of the Helm repository for Argo CD"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart_name" {
  description = "Name of the Helm chart"
  type        = string
  default     = "argo-cd"
}

variable "chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "5.52.0"
}

variable "values_file" {
  description = "Path to the values.yaml file"
  type        = string
  default     = ""
}

variable "additional_values" {
  description = "Additional Helm values to merge with values.yaml"
  type        = string
  default     = ""
}

variable "helm_sets" {
  description = "List of parameters to set"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "timeout" {
  description = "Time in seconds to wait for Helm deployment"
  type        = number
  default     = 600
}

variable "atomic" {
  description = "If true, the deployment will be rolled back on failure"
  type        = bool
  default     = true
}

variable "wait" {
  description = "If true, wait for resources to be ready"
  type        = bool
  default     = true
}

variable "use_local_chart" {
  description = "If true, use a local chart instead of fetching from a repository"
  type        = bool
  default     = false
}

variable "local_chart_path" {
  description = "Path to the local Helm chart when use_local_chart is true"
  type        = string
  default     = ""
}