variable "cluster_name" {
  default = "prod-chat"
  type    = string
}

variable "cluster_version" {
  default = "1.28"
  type    = string
}

variable "instance_type" {
  default = "t3a.medium"
  type    = string
}
