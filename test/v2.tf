# Application node group variables
variable "application_instance_types" {
  description = "Instance types for the application node group."
  type        = list(string)
  default     = ["t3.medium"]
}
variable "application_node_group_desired_size" {
  description = "Desired size of the application node group."
  type        = number
  default     = 2
}
variable "application_node_group_max_size" {
  description = "Maximum size of the application node group."
  type        = number
  default     = 3
}
variable "application_node_group_min_size" {
  description = "Minimum size of the application node group."
  type        = number
  default     = 1
}
variable "application_node_group_max_unavailable" {
  description = "Maximum unavailable nodes during update for application node group."
  type        = number
  default     = 1
}

# GPU node group variables
variable "gpu_instance_types" {
  description = "Instance types for the GPU node group."
  type        = list(string)
  default     = ["g4dn.xlarge"]
}
variable "gpu_node_group_desired_size" {
  description = "Desired size of the GPU node group."
  type        = number
  default     = 1
}
variable "gpu_node_group_max_size" {
  description = "Maximum size of the GPU node group."
  type        = number
  default     = 2
}
variable "gpu_node_group_min_size" {
  description = "Minimum size of the GPU node group."
  type        = number
  default     = 1
}
variable "gpu_node_group_max_unavailable" {
  description = "Maximum unavailable nodes during update for GPU node group."
  type        = number
  default     = 1
}

# ARM node group variables
variable "arm_app_instance_types" {
  description = "Instance types for the ARM node group."
  type        = list(string)
  default     = ["m6g.medium"]
}
variable "arm_app_node_group_desired_size" {
  description = "Desired size of the ARM node group."
  type        = number
  default     = 1
}
variable "arm_app_node_group_max_size" {
  description = "Maximum size of the ARM node group."
  type        = number
  default     = 2
}
variable "arm_app_node_group_min_size" {
  description = "Minimum size of the ARM node group."
  type        = number
  default     = 1
}
variable "arm_app_node_group_max_unavailable" {
  description = "Maximum unavailable nodes during update for ARM node group."
  type        = number
  default     = 1
}