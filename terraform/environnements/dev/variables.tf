variable "region" {
  type        = string
  description = "The region of the deployment"
  default     = "eu-west-3"
}

variable "git_repo_url" {
  description = "Repo url"
  type        = string
  default = "https://github.com/Leomendoza13/eks-scalable-devops-platform"
}