output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.arn
}

output "fluentbit_role_arn" {
  description = "IAM role ARN for Fluent Bit"
  value       = aws_iam_role.fluentbit_role.arn
}