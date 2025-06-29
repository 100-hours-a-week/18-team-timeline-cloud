variable "cluster_name" {
    type = string
}

variable "node_iam_role_arns" {
    type = list(string)
}

variable "additional_role_arns" {
  description = "List of additional IAM Role ARNs to be added (e.g., Bastion Host)"
  type        = list(string)
  default     = []
}

variable "default_tags" {
  description = "Common tags"
  type        = map(string)
}