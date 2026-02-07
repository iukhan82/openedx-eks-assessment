variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EFS will be created"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets for EFS mount targets"
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to access EFS (usually your VPC CIDR)"
}