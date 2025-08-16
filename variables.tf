variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

# variable "subnet_ids" {
#   description = "List of all subnet IDs (private and public) for the EKS cluster"
#   type        = list(string)
#   default     = []
# }


variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
  default     = []
}

# variable "vpc_id" {
#   description = "VPC ID for the EKS cluster"
#   type        = string
# }

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}