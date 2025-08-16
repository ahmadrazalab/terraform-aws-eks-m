
# exporting the ALB DNS name from the cloudflare module
output "alb_dns_name" {
  value = module.eks.alb_dns_name

}