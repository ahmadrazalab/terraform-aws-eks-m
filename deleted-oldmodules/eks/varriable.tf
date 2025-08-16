variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "tracemypods"
}

# Node group variables
variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Application node group
variable "application_node_group_desired_size" {
  type    = number
  default = 2
}
variable "application_node_group_max_size" {
  type    = number
  default = 3
}
variable "application_node_group_min_size" {
  type    = number
  default = 1
}
variable "application_node_group_max_unavailable" {
  type    = number
  default = 1
}
variable "application_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

# GPU node group
variable "gpu_node_group_desired_size" {
  type    = number
  default = 1
}
variable "gpu_node_group_max_size" {
  type    = number
  default = 2
}
variable "gpu_node_group_min_size" {
  type    = number
  default = 0
}
variable "gpu_node_group_max_unavailable" {
  type    = number
  default = 1
}
variable "gpu_instance_types" {
  type    = list(string)
  default = ["g4dn.xlarge"]
}

# ARM node group
variable "arm_app_node_group_desired_size" {
  type    = number
  default = 1
}
variable "arm_app_node_group_max_size" {
  type    = number
  default = 2
}
variable "arm_app_node_group_min_size" {
  type    = number
  default = 0
}
variable "arm_app_node_group_max_unavailable" {
  type    = number
  default = 1
}
variable "arm_app_instance_types" {
  type    = list(string)
  default = ["m6g.medium"]
}