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
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])

  role       = aws_iam_role.node_group_role.name
  policy_arn = each.value
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.premium_cluster.name
  node_group_name = "demo-${random_string.name_suffix.result}"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = ["subnet-0198d10b83f4389a0", "subnet-0f4566efb7ac51c04", "subnet-0dfd99820b62e7ae7"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_policies
  ]

  tags = {
      Name = "Premium EKS Node-1"
      Env = "development"
    }



}

