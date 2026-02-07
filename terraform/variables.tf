variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "openedx-eks"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "AZs for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "db_username" {
  description = "RDS MySQL master username"
  type        = string
}

variable "db_password" {
  description = "RDS MySQL master password"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "SSH key pair name for MongoDB EC2"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.28"
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "openedx"
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Base domain for Open edX (e.g. myopenedx.com)"
  type        = string
}

variable "acme_email" {
  description = "Email used for Let's Encrypt registration"
  type        = string
}

variable "allowed_cidrs" {
  description = "CIDR blocks allowed to access EFS"
  type        = list(string)
  default     = ["10.0.0.0/16"] # match your VPC CIDR
}

variable "email_host" {}
variable "email_port" {}
variable "email_host_user" {}
variable "email_host_password" {}
variable "default_from_email" {}
variable "lms_host" {}
variable "cms_host" {}
variable "platform_name" {}