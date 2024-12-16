variable "eks_cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "enabled_cluster_log_types" {
  description = "List of enabled cluster log types"
  type        = list(string)
  default     = []
}

variable "cluster_tags" {
  description = "Tags to apply to the EKS cluster"
  type        = map(string)
  default     = {
    Name = "Premium EKS Cluster"
    Env  = "development"
  }
}

variable "node_group_policies" {
  description = "IAM policies for the EKS node group role"
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
}

variable "node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
}

variable "node_group_max_unavailable" {
  description = "Maximum unavailable nodes during update"
  type        = number
  default     = 1
}

variable "node_group_tags" {
  description = "Tags to apply to the node group"
  type        = map(string)
  default     = {
    Name = "Premium EKS Node-1"
    Env  = "development"
  }
}
