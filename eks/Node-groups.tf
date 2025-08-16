
############### Node Groups ######################
resource "aws_eks_node_group" "application_node_group" {
  cluster_name    = aws_eks_cluster.premium_cluster.name
  version         = var.eks-node-version
  node_group_name = "application_node_group" ####-${random_string.name_suffix.result}"
  node_role_arn   = aws_iam_role.node_group_role.arn
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
  ami_type       = "AL2023_x86_64_STANDARD" # Amazon Linux 2 AMI with ARM support

  # node_repair_config {
  #   enabled = true
  # }

  tags = {
    Name = "application_node_group"
  }
}



######################## GPU NODE GROUP ########################
resource "aws_eks_node_group" "gpu_node_groups" {
  cluster_name    = aws_eks_cluster.premium_cluster.name
  version = var.eks-node-version
  node_group_name = "tracemypods_ai_gpu_node_groups"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.private_subnet_ids

  # lifecycle {
  #   create_before_destroy = true
  # }

  scaling_config {
    desired_size = var.gpu_node_group_desired_size
    max_size     = var.gpu_node_group_max_size
    min_size     = var.gpu_node_group_min_size
  }

  instance_types = var.gpu_instance_types
  disk_size = 30
  # addding taints on all the nodes created by this node group
  taint {
    key = "gpu"
    value = "t4"
    effect = "NO_SCHEDULE"
  }

  # Adding labels to the nodes in this node group
  labels = {
    gpu = "t4"
    node-type = "gpu"
  }


update_config {
    max_unavailable = var.gpu_node_group_max_unavailable
  }
  # depends_on = [aws_iam_role_policy_attachment.node_group_policies]
  ami_type = "AL2_x86_64_GPU"  # Amazon Linux 2 AMI with GPU support

# node_repair_config {
#   enabled = true
# }

  tags = {
    Name = "gpu_node_groups"

  }
}



################ ARM NODE GROUP ######################

resource "aws_eks_node_group" "arm_app_node_group" {
  cluster_name    = aws_eks_cluster.premium_cluster.name
  version = var.eks-node-version
  node_group_name = "tracemypods_arm_app_node_group"   # -${random_string.name_suffix.result}"
  node_role_arn   = aws_iam_role.node_group_role.arn
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
  disk_size = 20
  ami_type = "AL2023_ARM_64_STANDARD"  # Amazon Linux 2 AMI with ARM support

  node_repair_config {
    enabled = true
  }

  tags = {
    Name = "arm_app_node_group"
  }
}