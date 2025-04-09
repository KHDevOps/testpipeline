resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins server"
  revoke_rules_on_delete = true

  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for Bastion host"
  
  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group_rule" "jenkins_web" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Jenkins web UI access from admin IP only"
}

resource "aws_security_group_rule" "jenkins_https_outbound" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Allow HTTPS outbound for updates"
}

resource "aws_security_group_rule" "jenkins_http_outbound" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Allow HTTP outbound for updates"
}

resource "aws_security_group_rule" "bastion_ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.bastion_sg.id
  description       = "SSH access from admin IP only"
}

resource "aws_security_group_rule" "bastion_https_egress" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
  description       = "HTTPS outbound for updates"
}

resource "aws_security_group_rule" "bastion_ssh_egress" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jenkins_sg.id
  security_group_id        = aws_security_group.bastion_sg.id
  description              = "SSH to Jenkins instance only"
}

resource "aws_security_group_rule" "jenkins_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.jenkins_sg.id
  description              = "SSH from bastion only"
}