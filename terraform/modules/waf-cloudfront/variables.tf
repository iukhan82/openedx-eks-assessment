variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "origin_domain_name" {
  description = "Origin domain name (e.g., ALB or Nginx Ingress Controller DNS)"
  type        = string
}

variable "waf_ip_set" {
  description = "List of allowed IPs (for WAF whitelist)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}