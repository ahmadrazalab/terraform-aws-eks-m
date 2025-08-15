


# Application Node Group
resource "aws_eks_node_group" "application" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-application"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = var.private_subnet_ids
  scaling_config {
    desired_size = var.application_node_group_desired_size
    max_size     = var.application_node_group_max_size
    min_size     = var.application_node_group_min_size
  }
  update_config {
    max_unavailable = var.application_node_group_max_unavailable
  }
  instance_types = var.application_instance_types
  disk_size      = 30
  ami_type       = "AL2023_x86_64_STANDARD"
  node_repair_config {
    enabled = true
  }
  tags = merge(var.tags, { Name = "application_node_group" })
}

# GPU Node Group
resource "aws_eks_node_group" "gpu" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-gpu"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = var.private_subnet_ids
  scaling_config {
    desired_size = var.gpu_node_group_desired_size
    max_size     = var.gpu_node_group_max_size
    min_size     = var.gpu_node_group_min_size
  }
  update_config {
    max_unavailable = var.gpu_node_group_max_unavailable
  }
  instance_types = var.gpu_instance_types
  disk_size      = 30
  taint {
    key    = "gpu"
    value  = "t4"
    effect = "NO_SCHEDULE"
  }
  labels = {
    gpu       = "t4"
    node-type = "gpu"
  }
  ami_type = "AL2_x86_64_GPU"
  node_repair_config {
    enabled = true
  }
  tags = merge(var.tags, { Name = "gpu_node_group" })
}

# ARM Node Group
resource "aws_eks_node_group" "arm" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-arm"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = var.private_subnet_ids
  scaling_config {
    desired_size = var.arm_app_node_group_desired_size
    max_size     = var.arm_app_node_group_max_size
    min_size     = var.arm_app_node_group_min_size
  }
  update_config {
    max_unavailable = var.arm_app_node_group_max_unavailable
  }
  instance_types = var.arm_app_instance_types
  disk_size      = 20
  ami_type       = "AL2023_ARM_64_STANDARD"
  node_repair_config {
    enabled = true
  }
  tags = merge(var.tags, { Name = "arm_app_node_group" })
}