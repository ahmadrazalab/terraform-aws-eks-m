variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
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

}

variable "application_instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
}

variable "gpu_instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
}



variable "application_node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 1
}

variable "application_node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 2
}

variable "application_node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
}

variable "application_node_group_max_unavailable" {
  description = "Maximum unavailable nodes during update"
  type        = number
  default     = 1
}


##
variable "gpu_node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 1
}

variable "gpu_node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 2
}

variable "gpu_node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
}

variable "gpu_node_group_max_unavailable" {
  description = "Maximum unavailable nodes during update"
  type        = number
  default     = 1
}
##

variable "node_group_tags" {
  description = "Tags to apply to the node group"
  type        = map(string)
}


variable "eks-version" {
  description = "EKS version"
  type        = string
}

variable "eks-node-version" {
  description = "EKS version"
  type        = string
}


variable "arm_app_instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
}

variable "arm_app_node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 1
}
variable "arm_app_node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 2
}
variable "arm_app_node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
}
variable "arm_app_node_group_max_unavailable" {
  description = "Maximum unavailable nodes during update"
  type        = number
  default     = 1
}


variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for AWS Load Balancer Controller"
  type        = string
}
