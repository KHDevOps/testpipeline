variable "bastion_sg_id" {
    description = "Bastion security group id"
    type = string
}

variable "jenkins_sg_id" {
    description = "Jenkins security group id"
    type = string
}

variable "public_subnet_bastion_id" {
    description = "Public Bastion subnet Id"
    type = string
}

variable "private_subnet_jenkins_id" {
    description = "Public Jenkins subnet Id"
    type = string
}

variable "public_key_ssh_path" {
    description = "Ssh path"
    type = string
}
