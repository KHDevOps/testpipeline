output bastion_instance_id {
    value =  aws_instance.bastion.id
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}