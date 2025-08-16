# data "external" "lb_policy" {
#   program = ["bash", "-c", "curl -sSL https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.0/docs/install/iam_policy.json"]
# }

resource "aws_iam_policy" "aws_lb_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM Policy for AWS LB Controller"
  # policy      = data.external.lb_policy.result
  policy      = file("${path.module}/iam_policy.json")
  tags = {
    Name = "AWSLoadBalancerControllerIAMPolicy"
  }
}



data "aws_iam_openid_connect_provider" "oidc" {
  url = aws_eks_cluster.premium_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "lb_controller_role" {
  name = "aws-load-balancer-controller-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.oidc.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(data.aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lb_policy" {
  role       = aws_iam_role.lb_controller_role.name
  policy_arn = aws_iam_policy.aws_lb_controller.arn
}

resource "kubernetes_service_account" "aws_lb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lb_controller_role.arn
    }
  }
}




## helm lb install 
resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = var.vpc_id
    }
  ]

  depends_on = [
    kubernetes_service_account.aws_lb_controller
  ]
}

