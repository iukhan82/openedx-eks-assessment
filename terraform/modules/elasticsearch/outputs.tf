output "opensearch_endpoint" {
  description = "OpenSearch domain endpoint"
  value       = aws_opensearch_domain.main.endpoint
}

output "opensearch_security_group_id" {
  description = "Security group ID for OpenSearch"
  value       = aws_security_group.opensearch_sg.id
}