output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.premium_cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = aws_eks_cluster.premium_cluster.endpoint
}
