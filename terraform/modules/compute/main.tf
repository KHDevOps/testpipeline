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
  
  monitoring = false
  
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  
  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }
  
  associate_public_ip_address = false
  
  tags = {
    Name = "jenkins-server"
  }
}

# Instance Bastion
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.jenkins_key.key_name
  vpc_security_group_ids = [var.bastion_sg_id]
  subnet_id              = var.public_subnet_bastion_id
  
  monitoring = false
  
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }
  
  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }
  
  tags = {
    Name = "jenkins-bastion"
  }
}