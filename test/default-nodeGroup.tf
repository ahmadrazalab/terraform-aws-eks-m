# Additional node group with t3a.medium instance type
resource "aws_eks_node_group" "default_node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-default-node-group"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = var.private_subnet_ids
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  instance_types = ["t3a.medium"]
  tags           = merge(var.tags, { Name = "${var.cluster_name}-t3a-medium" })
}
