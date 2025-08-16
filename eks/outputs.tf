output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.premium_cluster.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS control plane"
  value       = aws_eks_cluster.premium_cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for the cluster"
  value       = aws_eks_cluster.premium_cluster.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "The security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.premium_cluster.vpc_config[0].cluster_security_group_id
}

output "cluster_status" {
  description = "The current status of the EKS cluster"
  value       = aws_eks_cluster.premium_cluster.status
}

