variable "cidr_prefix" {
  description = "CIDR prefix for the VPC"
  default     = "172.16"
  type        = string
}

variable "name" {
  description = "Name of the VPC"
  default     = "iam-session"
  type        = string
}

