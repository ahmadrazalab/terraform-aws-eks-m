output "cluster_name" {
  value = aws_eks_cluster.premiumcluster.name
}

output "oidc_issuer" {
  value = aws_eks_cluster.premiumcluster.identity[0].oidc[0].issuer
}