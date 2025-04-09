# Récupération de l'AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Création de la paire de clés
resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = file(var.public_key_ssh_path)
}

# Instance Jenkins
resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.jenkins_key.key_name
  vpc_security_group_ids = [var.jenkins_sg_id]
  subnet_id              = var.private_subnet_jenkins_id
  
  monitoring = true
  
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  
  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
  
  associate_public_ip_address = false
  ebs_optimized = true
  
  tags = {
    Name = "jenkins-server"
  }

  user_data = <<-EOF
    #!/bin/bash
    # Mise à jour du système
    yum update -y
    
    # Installation de Docker
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user
    
    # Installation de Docker Compose
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    # Création du répertoire pour les données Jenkins
    mkdir -p /var/jenkins_home
    chown 1000:1000 /var/jenkins_home
    
    # Création du docker-compose.yml pour Jenkins
    cat > /home/ec2-user/docker-compose.yml <<'EOL'
    version: '3'
    services:
      jenkins:
        image: jenkins/jenkins:lts
        container_name: jenkins
        user: root
        ports:
          - "8080:8080"
          - "50000:50000"
        volumes:
          - /var/jenkins_home:/var/jenkins_home
          - /var/run/docker.sock:/var/run/docker.sock
        restart: always
    EOL
    
    # Lancement de Jenkins via Docker Compose
    cd /home/ec2-user
    docker-compose up -d
  EOF
}

# Instance Bastion
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.jenkins_key.key_name
  vpc_security_group_ids = [var.bastion_sg_id]
  subnet_id              = var.public_subnet_bastion_id
  
  monitoring = true
  
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
  
  tags = {
    Name = "jenkins-bastion"
  }
}