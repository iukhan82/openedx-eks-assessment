variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "log_stream_name" {
  description = "Name of the CloudWatch log stream"
  type        = string
}

variable "retention_days" {
  description = "Retention period for logs in days"
  type        = number
  default     = 30
}

variable "prefix" {
  description = "Prefix for IAM role/policy names"
  type        = string
  default     = "openedx"
}

variable "tags" {
  description = "Tags to apply to CloudWatch resources"
  type        = map(string)
  default     = {}
}