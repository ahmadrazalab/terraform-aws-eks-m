
resource "aws_eks_cluster" "premium_cluster" {
  name = var.cluster_name

  role_arn = aws_iam_role.eks_autocluster_role.arn
  version  = var.eks-version


  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  upgrade_policy {
    support_type = "STANDARD"
  }

  # enabled_cluster_log_types = ["api", "audit", "authenticator"]


  vpc_config {
    subnet_ids              = var.private_subnet_ids
    # endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"] # Adjust CIDR blocks as needed for security

  }
  tags = var.cluster_tags
}


## OIDC Provider for EKS
# This provider is used for the AWS Load Balancer Controller
# and other AWS services that require IAM roles for service accounts.
# Get EKS cluster details
data "aws_eks_cluster" "oidc" {
  name = aws_eks_cluster.premium_cluster.name
}

# Get the TLS thumbprint from the OIDC issuer
data "tls_certificate" "oidc_thumbprint" {
  url = aws_eks_cluster.premium_cluster.identity[0].oidc[0].issuer
}

# Create the OIDC provider
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_thumbprint.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.premium_cluster.identity[0].oidc[0].issuer

  tags = {
    Name = "${aws_eks_cluster.premium_cluster.name}-oidc-provider"
  }
}
