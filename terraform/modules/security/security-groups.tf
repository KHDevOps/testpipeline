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
  count             = length(var.allowed_admin_cidrs) > 0 ? 1 : 0
  security_group_id = aws_security_group.eks_cluster.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = var.allowed_admin_cidrs
  description       = "Allow admin workstations to communicate with the cluster API Server"
}