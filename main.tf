
resource "random_string" "name_suffix" {
  length  = 6
  upper   = false
  special = false
}

# Cluster Configuration
resource "aws_eks_cluster" "premium_cluster" {
  name     = "premium-${random_string.name_suffix.result}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  access_config {
    authentication_mode = "API"
  }

  version = "1.31"

  upgrade_policy {
    support_type = "STANDARD"  # or "EXTENDED" (default)
  }


  vpc_config {
    subnet_ids              = ["subnet-0198d10b83f4389a0", "subnet-0f4566efb7ac51c04", "subnet-0dfd99820b62e7ae7"] # Replace with your private subnet IDs
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  kubernetes_network_config {
    service_ipv4_cidr = "10.100.0.0/16" # Adjust based on your requirements
  }

  enabled_cluster_log_types = []


  tags = {
      Name = "Premium EKS Cluster"
      Env = "development"
    }
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


