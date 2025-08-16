
variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "EKS control plane version."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for EKS."
  type        = list(string)
}

variable "node_group_instance_types" {
  description = "Instance types for the default node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_min_size" {
  description = "Minimum size of the node group."
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum size of the node group."
  type        = number
  default     = 3
}

variable "node_group_desired_size" {
  description = "Desired size of the node group."
  type        = number
  default     = 2
}

variable "tags" {
  description = "Global tags to apply to all resources."
  type        = map(string)
  default     = {}
}
