variable "region" {
  type        = string
  description = "The region of the deployment"
  default     = "eu-west-3"
}

variable "allowed_admin_cidrs" {
  description = "CDR list admins"
  type        = list(string)
  default     = []
}

variable "public_key_ssh_path" {
    description = "Ssh path"
    type = string
}

variable "git_repo_url" {
  description = "Repo url"
  type        = string
  default = "https://github.com/Leomendoza13/eks-scalable-devops-platform"
}