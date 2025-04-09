[jenkins]
jenkins-server ansible_host=${jenkins_ip} ansible_user=ec2-user

[bastion]
bastion ansible_host=${bastion_ip} ansible_user=ec2-user

[jenkins:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ec2-user@${bastion_ip}"'