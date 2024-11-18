resource "aws_eks_cluster" "prod_cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids         = data.aws_subnets.private.ids
    security_group_ids = [aws_security_group.cluster_sg.id]
    endpoint_private_access = true    # Enable private access if needed
    endpoint_public_access  = false   # Disable public access if needed
  }

  upgrade_policy {
    support_type = "STANDARD"  # or "EXTENDED" (default)
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.prod_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.aws_subnets.private.ids
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policy
  ]

  tags = {
    Name = "${var.cluster_name}-node-group"
  }
}
