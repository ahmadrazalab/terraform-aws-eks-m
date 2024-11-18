provider "aws" {
  region = "ap-south-1"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.prod_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.prod_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = aws_eks_cluster.prod_cluster.name
}
