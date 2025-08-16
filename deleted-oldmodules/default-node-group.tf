
# resource "aws_eks_node_group" "default" {
#   cluster_name    = aws_eks_cluster.this.name
#   node_group_name = "${var.cluster_name}-default"
#   node_role_arn   = aws_iam_role.eks_node.arn
#   subnet_ids      = var.private_subnet_ids
#   scaling_config {
#     desired_size = var.node_group_desired_size
#     max_size     = var.node_group_max_size
#     min_size     = var.node_group_min_size
#   }
#   instance_types = var.node_group_instance_types
#   tags           = var.tags
# }


# resource "aws_iam_role" "eks_node" {
#   name = "${var.cluster_name}-eks-node-role"
#   assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json
# }

# data "aws_iam_policy_document" "eks_node_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }
