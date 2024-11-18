output "cluster_endpoint" {
  value = aws_eks_cluster.prod_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.prod_cluster.name
}

output "cluster_security_group_id" {
  value = aws_security_group.cluster_sg.id
}

output "node_security_group_id" {
  value = aws_security_group.node_group_sg.id
}
