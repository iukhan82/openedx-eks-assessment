variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for MongoDB"
  type        = string
}

variable "subnets" {
  description = "Private subnet IDs for MongoDB EC2"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for MongoDB"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "SSH key pair name for EC2 access"
  type        = string
}

variable "mongo_port" {
  description = "MongoDB port"
  type        = number
  default     = 27017
}

variable "mongo_volume_size" {
  description = "EBS volume size in GB"
  type        = number
  default     = 20
}