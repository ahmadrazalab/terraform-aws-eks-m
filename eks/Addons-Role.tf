

# ADDON # Amazon VPC CNI 

resource "aws_iam_role" "AmazonEKSPodIdentityAmazonVPCCNIRole" {
  name = "AmazonEKSPodIdentityAmazonVPCCNIRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "pods.eks.amazonaws.com"
      },
      Action = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}
resource "aws_iam_role_policy_attachment" "eks_pod_identity_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.AmazonEKSPodIdentityAmazonVPCCNIRole.name
}


# ADDON # Amazon EBS CSI Driver 

resource "aws_iam_role" "AmazonEKSPodIdentityAmazonEBSCSIDriverRole" {
  name = "AmazonEKSPodIdentityAmazonEBSCSIDriverRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "pods.eks.amazonaws.com"
      },
      Action = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}
resource "aws_iam_role_policy_attachment" "eks_pod_identity_ebs_csi_driver_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.AmazonEKSPodIdentityAmazonEBSCSIDriverRole.name
}

## add role for AmazonEKSPodIdentityAmazonCloudWatchObservabilityRole

resource "aws_iam_role" "AmazonEKSPodIdentityAmazonCloudWatchObservabilityRole" {
  name = "AmazonEKSPodIdentityAmazonCloudWatchObservabilityRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "pods.eks.amazonaws.com"
      },
      Action = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}
resource "aws_iam_role_policy_attachment" "eks_pod_identity_cloudwatch_observability_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.AmazonEKSPodIdentityAmazonCloudWatchObservabilityRole.name
}

# attach this roles to cloudwatch-observability-sa service account arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
resource "aws_iam_role_policy_attachment" "eks_pod_identity_cloudwatch_observability_policy_attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.AmazonEKSPodIdentityAmazonCloudWatchObservabilityRole.name
}




















