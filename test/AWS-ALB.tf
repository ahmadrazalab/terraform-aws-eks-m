# # data "external" "lb_policy" {
# #   program = ["bash", "-c", "curl -sSL https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.0/docs/install/iam_policy.json"]
# # }

# resource "aws_iam_policy" "aws_lb_controller" {
#   name        = "AWSLoadBalancerControllerIAMPolicy"
#   description = "IAM Policy for AWS LB Controller"
#   # policy      = data.external.lb_policy.result
#   policy      = file("${path.module}/iam_policy.json")
#   tags = {
#     Name = "AWSLoadBalancerControllerIAMPolicy"
#   }
# }



# data "aws_iam_openid_connect_provider" "oidc" {
#   url = aws_eks_cluster.eks_cluster_block.identity[0].oidc[0].issuer
# }

# resource "aws_iam_role" "lb_controller_role" {
#   name = "aws-load-balancer-controller-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Federated = data.aws_iam_openid_connect_provider.oidc.arn
#       },
#       Action = "sts:AssumeRoleWithWebIdentity",
#       Condition = {
#         StringEquals = {
#           "${replace(data.aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
#         }
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "attach_lb_policy" {
#   role       = aws_iam_role.lb_controller_role.name
#   policy_arn = aws_iam_policy.aws_lb_controller.arn
# }

# resource "kubernetes_service_account" "aws_lb_controller" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.lb_controller_role.arn
#     }
#   }
# }




# ## helm lb install 
# resource "helm_release" "aws_lb_controller" {
#   name       = "aws-load-balancer-controller"
#   chart      = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   namespace  = "kube-system"

#   set = [
#     {
#       name  = "clusterName"
#       value = var.cluster_name
#     },
#     {
#       name  = "serviceAccount.create"
#       value = "false"
#     },
#     {
#       name  = "serviceAccount.name"
#       value = "aws-load-balancer-controller"
#     },
#     {
#       name  = "region"
#       value = var.aws_region
#     },
#     {
#       name  = "vpcId"
#       value = var.vpc_id
#     }
#   ]

#   depends_on = [
#     kubernetes_service_account.aws_lb_controller
#   ]
# }



# ---------------------


# # ALB Ingress for TraceMyPods


# resource "kubernetes_ingress_v1" "ai_frontend_ingress" {
#   metadata {
#     name      = var.alb_ingress_name
#     namespace = var.alb_ingress_namespace
#     annotations = merge({
#       "alb.ingress.kubernetes.io/scheme"              = var.alb_scheme
#       "alb.ingress.kubernetes.io/target-type"         = var.alb_target_type
#       "alb.ingress.kubernetes.io/listen-ports"        = var.alb_listen_ports
#       "alb.ingress.kubernetes.io/certificate-arn"     = var.alb_certificate_arn
#       "alb.ingress.kubernetes.io/ssl-policy"          = var.alb_ssl_policy
#       "alb.ingress.kubernetes.io/healthcheck-path"    = var.alb_healthcheck_path
#     }, var.alb_additional_annotations)
#     labels = merge({
#       "Environment" = var.environment,
#       "Project"     = var.project
#     }, var.alb_additional_labels)
#   }

#   spec {
#     ingress_class_name = var.alb_ingress_class

#     rule {
#       host = var.alb_host

#       http = var.alb_paths
#     }
#   }
# }

# data "kubernetes_ingress_v1" "ai_frontend_ingress_status" {
#   metadata {
#     name      = kubernetes_ingress_v1.ai_frontend_ingress.metadata[0].name
#     namespace = kubernetes_ingress_v1.ai_frontend_ingress.metadata[0].namespace
#   }
# }

# output "alb_dns_name" {
#   value = try(data.kubernetes_ingress_v1.ai_frontend_ingress_status.status[0].load_balancer[0].ingress[0].hostname, "")
# }



# # ALB Ingress variables
# variable "alb_ingress_name" {
#   description = "Name of the ALB ingress resource."
#   type        = string
#   default     = "tracemypods-ingress"
# }

# variable "alb_ingress_namespace" {
#   description = "Namespace for the ALB ingress."
#   type        = string
#   default     = "ai-assistant"
# }

# variable "alb_scheme" {
#   description = "ALB scheme (internet-facing or internal)."
#   type        = string
#   default     = "internet-facing"
# }

# variable "alb_target_type" {
#   description = "ALB target type (ip or instance)."
#   type        = string
#   default     = "ip"
# }

# variable "alb_listen_ports" {
#   description = "ALB listen ports in JSON format."
#   type        = string
#   default     = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
# }

# variable "alb_certificate_arn" {
#   description = "ARN of the ACM certificate for HTTPS."
#   type        = string
#   default     = ""
# }

# variable "alb_ssl_policy" {
#   description = "SSL policy for the ALB."
#   type        = string
#   default     = "ELBSecurityPolicy-2016-08"
# }

# variable "alb_healthcheck_path" {
#   description = "Healthcheck path for the ALB."
#   type        = string
#   default     = "/"
# }

# variable "alb_additional_annotations" {
#   description = "Additional annotations for the ALB ingress."
#   type        = map(string)
#   default     = {}
# }

# variable "alb_additional_labels" {
#   description = "Additional labels for the ALB ingress."
#   type        = map(string)
#   default     = {}
# }

# variable "alb_ingress_class" {
#   description = "Ingress class name for the ALB."
#   type        = string
#   default     = "alb"
# }

# variable "alb_host" {
#   description = "Host for the ALB ingress rule."
#   type        = string
#   default     = "assist.ahmadraza.in"
# }

# variable "alb_paths" {
#   description = "List of HTTP path rules for the ALB ingress. Should be a list of objects."
#   type        = any
#   default     = []
# }



# ALB DNS Name
# output "alb_dns_name" {
#   description = "DNS name of the ALB ingress."
#   value       = try(data.kubernetes_ingress_v1.ai_frontend_ingress_status.status[0].load_balancer[0].ingress[0].hostname, "")
# }

