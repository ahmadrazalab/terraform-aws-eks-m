resource "random_string" "name_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_eks_cluster" "premium_cluster" {
  name     = "premium-${random_string.name_suffix.result}"
  role_arn = var.eks_cluster_role_arn

  access_config {
    authentication_mode = "API"
  }

  version = "1.31"

  upgrade_policy {
    support_type = "STANDARD"
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  kubernetes_network_config {
    service_ipv4_cidr = "10.100.0.0/16"
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = var.cluster_tags
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.premium_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.premium_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.premium_cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "eks_pod_identity_agent" {
  cluster_name = aws_eks_cluster.premium_cluster.name
  addon_name   = "eks-pod-identity-agent"
}

resource "aws_iam_role" "node_group_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_group_policies" {
  for_each = toset(var.node_group_policies)

  role       = aws_iam_role.node_group_role.name
  policy_arn = each.value
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.premium_cluster.name
  node_group_name = "demo-${random_string.name_suffix.result}"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    max_unavailable = var.node_group_max_unavailable
  }

  depends_on = [aws_iam_role_policy_attachment.node_group_policies]

  tags = var.node_group_tags
}
