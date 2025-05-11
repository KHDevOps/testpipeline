# Security Group for EKS Control Plane
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for the EKS control plane"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

# Security Group for EKS Nodes
resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}

#for now
# Allow all outbound traffic from the EKS cluster
resource "aws_security_group_rule" "cluster_egress_all" {
  security_group_id = aws_security_group.eks_cluster.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic from the EKS cluster"
}

# Allow all outbound traffic from the nodes
resource "aws_security_group_rule" "nodes_egress_all" {
  security_group_id = aws_security_group.eks_nodes.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic from the nodes"
}

# Allow all communication between the EKS cluster and nodes
resource "aws_security_group_rule" "nodes_to_cluster" {
  security_group_id        = aws_security_group.eks_cluster.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.eks_nodes.id
  description              = "Allow worker nodes to communicate with the cluster API Server"
}

resource "aws_security_group_rule" "cluster_to_nodes" {
  security_group_id        = aws_security_group.eks_nodes.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.eks_cluster.id
  description              = "Allow cluster control plane to communicate with worker nodes"
}

# Allow worker nodes to communicate with each other (self referencing rule)
resource "aws_security_group_rule" "nodes_internal" {
  security_group_id        = aws_security_group.eks_nodes.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.eks_nodes.id
  description              = "Allow nodes to communicate with each other"
}

# Allow admin access to the Kubernetes API from specific IPs
resource "aws_security_group_rule" "admin_api_access" {
  count             = length(var.admin_ips) > 0 ? 1 : 0
  security_group_id = aws_security_group.eks_cluster.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = var.admin_ips
  description       = "Allow admin workstations to communicate with the cluster API Server"
}

resource "aws_security_group" "lb_sg" {
  name        = "${var.environment}-monitoring-lb-sg"
  description = "Security Group for ALB serives monitoring"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.admin_ips
    description = "HTTP from allowed admin only"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.admin_ips
    description = "HTTPS from allowed admin only"
  }
  
  # Règles d'egress - vers les nœuds EKS sur les NodePorts
  egress {
    from_port       = 30000
    to_port         = 32767
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
    description     = "Trafic to EKS nodeports"
  }

  # Autoriser les requêtes DNS
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] 
    description = "DNS lookups"
  }

  #For now
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
    description = "All egress trafic is allowed"
  }

  tags = {
    Name        = "${var.environment}-monitoring-lb-sg"
    Environment = var.environment
  }
}