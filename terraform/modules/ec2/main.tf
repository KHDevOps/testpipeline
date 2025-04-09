terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro" 
  key_name               = aws_key_pair.jenkins_key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
  
  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins server"
  
  revoke_rules_on_delete = true

  tags = {
    Name = "jenkins-sg"
  }
}