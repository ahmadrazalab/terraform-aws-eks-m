resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.eks_cluster_block.name
  addon_name    = "kube-proxy"
  addon_version = "v1.32.3-eksbuild.2"
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.eks_cluster_block.name
  addon_name    = "coredns"
  addon_version = "v1.11.4-eksbuild.10"
  depends_on    = [aws_eks_node_group.application_node_group]
}

# Amazon EKS Pod Identity Agent Info
# Install EKS Pod Identity Agent to use EKS Pod Identity to grant AWS IAM permissions to pods through Kubernetes service accounts.
resource "aws_eks_addon" "eks_pod_identity_agent" {
  cluster_name  = aws_eks_cluster.eks_cluster_block.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.5-eksbuild.2"
}

resource "aws_eks_addon" "metrics_server" {
  cluster_name  = aws_eks_cluster.eks_cluster_block.name
  addon_name    = "metrics-server"
  addon_version = "v0.7.2-eksbuild.3"
  depends_on    = [aws_eks_node_group.application_node_group]
}

resource "aws_eks_addon" "node_monitoring" {
  cluster_name  = aws_eks_cluster.eks_cluster_block.name
  addon_name    = "eks-node-monitoring-agent"
  addon_version = "v1.2.0-eksbuild.1"
  depends_on    = [aws_eks_node_group.application_node_group]
}

############# ADDONS that require IAM roles #############

# Amazon VPC CNI Info
# Enable pod networking within your cluster.
resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = aws_eks_cluster.eks_cluster_block.name
  addon_name               = "vpc-cni"
  addon_version            = "v1.19.3-eksbuild.1"
  service_account_role_arn = aws_iam_role.AmazonEKSPodIdentityAmazonVPCCNIRole.arn
  # depends_on = [aws_eks_node_group.application_node_group]
  pod_identity_association {
    service_account = "aws-node"
    role_arn        = aws_iam_role.AmazonEKSPodIdentityAmazonVPCCNIRole.arn
  }

  depends_on = [
    aws_iam_role.AmazonEKSPodIdentityAmazonVPCCNIRole
  ]
}

# Amazon EBS CSI Driver Info
# Enable Amazon Elastic Block Storage (EBS) within your cluster.
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.eks_cluster_block.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.42.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.AmazonEKSPodIdentityAmazonEBSCSIDriverRole.arn
  pod_identity_association {
    service_account = "ebs-csi-controller-sa"
    role_arn        = aws_iam_role.AmazonEKSPodIdentityAmazonEBSCSIDriverRole.arn
  }
  depends_on = [aws_eks_node_group.application_node_group]
}

# resource "aws_eks_addon" "amazon-cloudwatch-observability" {
#   cluster_name             = aws_eks_cluster.eks_cluster_block.name
#   addon_name               = "amazon-cloudwatch-observability"
#   addon_version            = "v4.3.0-eksbuild.1"
#   service_account_role_arn = aws_iam_role.AmazonEKSPodIdentityAmazonCloudWatchObservabilityRole.arn
#   pod_identity_association {
#     service_account = "cloudwatch-observability-sa"
#     role_arn        = aws_iam_role.AmazonEKSPodIdentityAmazonCloudWatchObservabilityRole.arn
#   }
#   depends_on = [aws_eks_node_group.application_node_group]

# }
